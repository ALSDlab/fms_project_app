import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fmsproject/data/dtos/chat_data_dto.dart';
import 'package:fmsproject/data/dtos/message_data_dto.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/simple_logger.dart';
import '../core/result.dart';

class FirebaseChatData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //채팅방 리스트 로드(1회)
  Future<Result<List<ChatDataDto>>> getChatList(String userId) async {
    try {
      var snapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .get();

      List<ChatDataDto> chatList =
          snapshot.docs.map((doc) => ChatDataDto.fromJson(doc.data())).toList();

      return Result.success(chatList);
    } catch (e) {
      logger.info('Firestore getting chat list error => $e');
      return Result.error(e.toString());
    }
  }

  //채팅방 리스트 로드(실시간 로드)
  Stream<List<ChatDataDto>> getChatListStream(String userId) {
    try {
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatDataDto.fromJson(doc.data()))
              .toList());
    } catch (e) {
      logger.info(
          'Firestore Stream getting user-specific chat room data error => $e');
      return Stream.value([]); // 오류 발생 시 빈 리스트 반환
    }
  }

  // 특정 채팅방 불러오기
  Future<Result<ChatDataDto>> getChatRoomData(String chatId) async {
    try {
      DocumentSnapshot chatDoc =
          await _firestore.collection('chats').doc(chatId).get();

      if (chatDoc.exists) {
        ChatDataDto chatData =
            ChatDataDto.fromJson(chatDoc.data() as Map<String, dynamic>);
        return Result.success(chatData);
      } else {
        return const Result.error('Chat room not found');
      }
    } catch (e) {
      logger.info('Firestore getting chat room error => $e');
      return Result.error(e.toString());
    }
  }

  Stream<List<MessageDataDto>> getMessagesForUser(String userId) {
    try {
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .snapshots()
          .switchMap((chatSnapshot) {
        // 채팅방이 없는 경우
        if (chatSnapshot.docs.isEmpty) {
          return Stream.value(<MessageDataDto>[]);
        }

        // 모든 채팅방의 메시지 스트림을 합치기
        List<Stream<List<MessageDataDto>>> messageStreams =
            chatSnapshot.docs.map((chatDoc) {
          return _firestore
              .collection('chats')
              .doc(chatDoc.id)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(15)
              .snapshots()
              .map((messagesSnapshot) => messagesSnapshot.docs
                  .map((doc) => MessageDataDto.fromJson(doc.data()))
                  .toList());
        }).toList();

        // 여러 스트림을 하나로 합치기 (모든 채팅방의 메시지를 포함)
        return CombineLatestStream.list(messageStreams).map((listOfMessages) {
          List<MessageDataDto> allMessages = [];
          for (var messages in listOfMessages) {
            allMessages.addAll(messages);
          }
          // 전체 메시지를 타임스탬프 기준으로 정렬
          allMessages.sort((a, b) {
            int secondsDiff = b.timestamp!.seconds - a.timestamp!.seconds;
            if (secondsDiff != 0) return secondsDiff;
            return b.timestamp!.nanoseconds - a.timestamp!.nanoseconds;
          });
          return allMessages;
        });
      });
    } catch (e) {
      logger.info(
          'Firestore Stream getting user-specific message data error => $e');
      return Stream.value([]); // 오류 발생 시 빈 리스트 반환
    }
  }

  // 이전 메시지를 로드
  Future<Result<List<MessageDataDto>>> fetchMoreMessages(
      String chatId, Timestamp lastTimestamp) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .startAfter([lastTimestamp]) // 마지막으로 가져온 메시지 이후의 데이터
          .limit(15)
          .get();

      List<MessageDataDto> oldMessages = snapshot.docs
          .map((doc) => MessageDataDto.fromJson(doc.data()))
          .toList();

      return Result.success(oldMessages);
    } catch (e) {
      logger.info('Firestore getting old messages error => $e');
      return Result.error(e.toString());
    }
  }

  // 특정 채팅방의 모든 메시지를 읽음 상태로 업데이트하는 메서드
  Future<Result<int>> markMessagesAsRead(String chatId, String userId) async {
    try {
      // 현재 사용자가 아직 읽지 않은 메시지만 가져오기
      QuerySnapshot messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .get();

      if (messagesSnapshot.docs.isEmpty) {
        return const Result.success(0); // 업데이트할 메시지가 없으면 바로 성공 반환
      }

      // batch 작업 생성
      WriteBatch batch = _firestore.batch();

      int unreadCount = 0;
      for (var doc in messagesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        var readByRaw = data['readByUsers'];
        List<String> readBy = (readByRaw is List)
            ? readByRaw.map((e) => e.toString()).toList() // `String` 변환
            : [];

        if (!readBy.contains(userId)) {
          batch.update(doc.reference, {
            'readByUsers': FieldValue.arrayUnion([userId]) // 안전한 업데이트 방식
          });
          unreadCount += 1;
        }
      }
      // batch 실행
      batch.commit().then((_) {
        logger.info('Firestore update completed!');
      }).catchError((error) {
        logger.info('Firestore update Failed: $error');
      });
      return Result.success(unreadCount);
    } catch (e) {
      logger.info('Marking messages as read error => $e');
      return Result.error(e.toString());
    }
  }

  // 채팅방 검색 메서드
  Future<Result<List<String>>> findChatRoom(
      String senderId, String receiverId) async {
    try {
      final chatRef = _firestore.collection('chats');

      // 기존 채팅방 검색
      QuerySnapshot existingChats = await chatRef
          .where('participants', isEqualTo: [senderId, receiverId]).get();
      List<String> chatRooms = [];

      for (var doc in existingChats.docs) {
        List<String> participants = List<String>.from(doc['participants']);

        if (participants.contains(receiverId)) {
          chatRooms.add(doc['chatId']);
        }
      }

      // 기존 채팅방이 있으면 해당 chatId를 반환
      if (chatRooms.isNotEmpty) {
        return Result.success(chatRooms);
      } else {
        // 채팅방이 없으면 새로운 chatId만 생성하여 반환
        DocumentReference newChatRef = chatRef.doc();
        final String newChatId = newChatRef.id;
        return Result.success([newChatId]);
      }
    } catch (e) {
      logger.info('Firestore find chat room error => $e');
      return Result.error(e.toString());
    }
  }

  // 채팅방 생성 메서드
  Future<Result<void>> createChatRoom(ChatDataDto chat) async {
    try {
      final chatRef = _firestore.collection('chats');

      // 새로운 채팅방 생성
      DocumentReference newChatRef = chatRef.doc(chat.chatId);

      // 파이어베이스에 채팅방 생성
      await newChatRef.set({
        'chatId': chat.chatId,
        'participants': chat.participants,
        'createdAt': chat.createdAt,
        'lastMessageId': chat.lastMessageId,
        'lastMessage': chat.lastMessage,
        'lastMessageAt': chat.lastMessageAt,
      });

      return const Result.success(null); // 성공적으로 생성됨
    } catch (e) {
      logger.info('Firestore create chat room error => $e');
      return Result.error(e.toString());
    }
  }

// 메시지 보내기 메서드
  Future<Result<void>> sendMessage(
      String chatId, MessageDataDto messageData) async {
    try {
      Map<String, dynamic> saveMessage = messageData.toJson();

      // 메시지 저장
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageData.messageId) // 문서 ID를 messageId로 설정
          .set(saveMessage);

      // 채팅방 마지막 메시지 업데이트
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage':
            messageData.type == 'image' ? "[Image]" : messageData.text,
        'lastMessageId': messageData.messageId,
        'lastMessageAt': messageData.timestamp,
      });

      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore send message error => $e');
      return Result.error(e.toString());
    }
  }

  Future<Result<String>> uploadImage(String chatId, File file) async {
    try {
      final ref = _storage.ref().child(
          "chat_images/$chatId/${DateTime.now().millisecondsSinceEpoch}.jpg");
      final uploadTask = ref.putFile(file);
      final completedTask = await uploadTask;
      final imgURL = await completedTask.ref.getDownloadURL();
      return Result.success(imgURL);
    } catch (e) {
      logger.info("Error uploading image: $e");
      return Result.error(e.toString());
    }
  }
}
