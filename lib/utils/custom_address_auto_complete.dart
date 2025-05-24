// 커스텀 주소 자동완성 위젯
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../domain/model/location_model.dart';

class CustomAddressAutocomplete extends StatefulWidget {
  final String apiKey;
  final TextEditingController controller;
  final Function() onClearClick;
  final Function(Place?) onSuggestionClick;
  final Function(Place) onSuggestionClickGetTextToUseForControl;
  final Color hoverColor;
  final Color selectionColor;
  final Widget Function(PlacePrediction prediction, int index) buildItem;
  final Widget clearButton;
  final bool autofocus;
  final EdgeInsets scrollPadding;
  final AutovalidateMode autovalidateMode;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextStyle style;
  final InputDecoration decoration;

  const CustomAddressAutocomplete({
    super.key,
    required this.apiKey,
    required this.controller,
    required this.onClearClick,
    required this.onSuggestionClick,
    required this.onSuggestionClickGetTextToUseForControl,
    required this.hoverColor,
    required this.selectionColor,
    required this.buildItem,
    required this.clearButton,
    this.autofocus = false,
    required this.scrollPadding,
    required this.autovalidateMode,
    required this.keyboardType,
    required this.textCapitalization,
    required this.textInputAction,
    required this.style,
    required this.decoration,
  });

  @override
  _CustomAddressAutocompleteState createState() => _CustomAddressAutocompleteState();
}

class _CustomAddressAutocompleteState extends State<CustomAddressAutocomplete> {
  List<PlacePrediction> _predictions = [];
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.controller.text.length > 2) {
        _fetchAddressSuggestions(widget.controller.text);
      } else {
        setState(() {
          _predictions = [];
        });
      }
    });
  }

  Future<void> _fetchAddressSuggestions(String input) async {
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
              '?input=$input'
              '&types=address'
              '&key=${widget.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = (data['predictions'] as List)
              .map((prediction) => PlacePrediction.fromJson(prediction))
              .toList();

          setState(() {
            _predictions = predictions;
            _isLoading = false;
          });
        } else {
          setState(() {
            _predictions = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _predictions = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _predictions = [];
        _isLoading = false;
      });
    }
  }

  Future<Place> _getPlaceDetails(String placeId) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
            '?place_id=$placeId'
            '&fields=address_component,geometry'
            '&key=${widget.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final result = data['result'];
        final components = result['address_components'] as List;
        final geometry = result['geometry']['location'];

        String? streetNumber;
        String? route;
        String? city;
        String? state;
        String? zipCode;
        String? country;

        for (var component in components) {
          final types = component['types'] as List;

          if (types.contains('street_number')) {
            streetNumber = component['long_name'];
          } else if (types.contains('route')) {
            route = component['short_name'];
          } else if (types.contains('locality')) {
            city = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          } else if (types.contains('postal_code')) {
            zipCode = component['long_name'];
          } else if (types.contains('country')) {
            country = component['long_name'];
          }
        }

        String? streetAddress;
        if (streetNumber != null && route != null) {
          streetAddress = '$streetNumber $route';
        }

        return Place(
          streetNumber: streetNumber,
          streetShort: route,
          streetAddress: streetAddress,
          city: city ?? '',
          state: state ?? '',
          zipCode: zipCode ?? '',
          country: country ?? '',
          lat: geometry['lat'],
          lng: geometry['lng'],
        );
      }
    }

    return Place();
  }

  void _onSuggestionSelected(PlacePrediction prediction) async {
    final place = await _getPlaceDetails(prediction.placeId);

    final textToUse = widget.onSuggestionClickGetTextToUseForControl(place);
    widget.controller.text = textToUse;

    setState(() {
      _predictions = [];
    });

    widget.onSuggestionClick(place);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          style: widget.style,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          scrollPadding: widget.scrollPadding,
          decoration: widget.decoration.copyWith(
            suffixIcon: widget.controller.text.isNotEmpty
                ? GestureDetector(
              onTap: () {
                widget.controller.clear();
                widget.onClearClick();
                setState(() {
                  _predictions = [];
                });
              },
              child: widget.clearButton,
            )
                : null,
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_predictions.isNotEmpty && _isFocused)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _onSuggestionSelected(_predictions[index]),
                  hoverColor: widget.hoverColor,
                  child: widget.buildItem(_predictions[index], index),
                );
              },
            ),
          ),
      ],
    );
  }
}