// 커스텀 주소 자동완성 위젯
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/location_model.dart';
import '../gif_progress_bar.dart';

class CustomAddressAutocomplete extends StatefulWidget {
  final String apiKey;
  final TextEditingController controller;
  final Function() onClearClick;
  final Function(Place?) onSuggestionClick;
  final Function(Place) onSuggestionClickGetTextToUseForControl;
  final Color hoverColor;
  final Color selectionColor; // Note: This is a parameter, ensure it's used if intended for TextField or items
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
  _CustomAddressAutocompleteState createState() =>
      _CustomAddressAutocompleteState();
}

class _CustomAddressAutocompleteState extends State<CustomAddressAutocomplete> {
  List<PlacePrediction> _predictions = [];
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  Timer? _debounce;
  bool _isLoading = false;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _programmaticTextChange = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(() {
      setState(() { // Update state for any UI dependent on _isFocused
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _updateOverlay(); // Show or update overlay when field is focused
      } else {
        _removeOverlay(); // Remove overlay when field loses focus
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _removeOverlay(); // Important to remove overlay on dispose
    super.dispose();
  }

  void _onTextChanged() {
    if (_programmaticTextChange) return; // Skip if text changed programmatically

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.controller.text.length > 2) {
        if (mounted) {
          setState(() {
            _isLoading = true;
            _predictions = []; // Clear previous predictions
          });
        }
        _updateOverlay(); // Show loading indicator in overlay
        _fetchAddressSuggestions(widget.controller.text);
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _predictions = [];
          });
        }
        _updateOverlay(); // Update overlay (will likely hide it)
      }
    });
  }

  Future<void> _fetchAddressSuggestions(String input) async {
    if (input.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _predictions = [];
        });
        _updateOverlay();
      }
      return;
    }

    // _isLoading is already set to true by _onTextChanged

    List<PlacePrediction> newPredictions = [];
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
              '?input=${Uri.encodeComponent(input)}' // Ensure input is URL encoded
              '&types=address'
              '&key=${widget.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          newPredictions = (data['predictions'] as List)
              .map((prediction) => PlacePrediction.fromJson(prediction))
              .toList();
        }
      }
    } catch (e) {
      // Handle or log error
      if (kDebugMode) {
        print('Error fetching address suggestions: $e');
      }
    }

    if (mounted) {
      setState(() {
        _predictions = newPredictions;
        _isLoading = false; // Finished loading
      });
      _updateOverlay(); // Refresh overlay with new predictions or lack thereof
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

        String? streetNumber, route, city, state, zipCode, country;

        for (var component in components) {
          final types = component['types'] as List;
          if (types.contains('street_number')) streetNumber = component['long_name'];
          if (types.contains('route')) route = component['short_name'];
          if (types.contains('locality')) city = component['long_name'];
          if (types.contains('administrative_area_level_1')) state = component['long_name'];
          if (types.contains('postal_code')) zipCode = component['long_name'];
          if (types.contains('country')) country = component['long_name'];
        }
        String? streetAddress = (streetNumber != null && route != null) ? '$streetNumber $route' : (route ?? streetNumber);


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
    return Place(); // Return empty Place on error
  }

  void _onSuggestionSelected(PlacePrediction prediction) async {
    _programmaticTextChange = true; // Set flag before changing text

    final place = await _getPlaceDetails(prediction.placeId);
    final textToUse = widget.onSuggestionClickGetTextToUseForControl(place);
    widget.controller.text = textToUse;
    // Move cursor to the end of the text
    widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));


    if (mounted) {
      setState(() {
        _predictions = []; // Clear predictions
        _isLoading = false;
      });
    }
    _removeOverlay(); // Hide overlay

    widget.onSuggestionClick(place);
    _focusNode.unfocus(); // Unfocus after selection

    // It's important to reset the flag after the current microtask queue is processed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _programmaticTextChange = false;
    });
  }

  void _createOverlayEntry() {
    // Remove existing overlay if any, before creating a new one
    _removeOverlay();

    // Ensure context is available for Overlay.of(context) and RenderBox
    if (!_focusNode.context!.mounted) return;

    final RenderBox renderBox = _focusNode.context!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width, // Match width of the TextField
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 40.0), // Space between TextField and suggestions
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220), // Max height for the list
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: GifProgressBar()),
                    ),
                  if (!_isLoading && _predictions.isEmpty && widget.controller.text.length > 2 && _isFocused)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "No results found.",
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (!_isLoading && _predictions.isNotEmpty)
                    Flexible( // Important for ListView within Column with constraints
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateOverlay() {
    if (!_isFocused && widget.controller.text.isEmpty) {
      _removeOverlay();
      return;
    }

    // Determine if there's anything to show in the overlay
    bool shouldShowOverlay = _isFocused &&
        (_isLoading ||
            _predictions.isNotEmpty ||
            (widget.controller.text.length > 2 && _predictions.isEmpty)); // Show "no results"

    if (shouldShowOverlay) {
      if (_overlayEntry == null) {
        _createOverlayEntry();
        if (_overlayEntry != null) {
          Overlay.of(context).insert(_overlayEntry!);
        }
      } else {
        _overlayEntry?.markNeedsBuild(); // Rebuild existing overlay
      }
    } else {
      _removeOverlay(); // Hide if no conditions met
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
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
              _programmaticTextChange = true; // Prevent search on clear
              widget.controller.clear();
              widget.onClearClick();
              if (mounted) {
                setState(() {
                  _predictions = [];
                  _isLoading = false;
                });
              }
              _removeOverlay();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _programmaticTextChange = false;
              });
            },
            child: widget.clearButton,
          )
              : null,
        ),
        onTap: () {
          // When TextField is tapped, ensure overlay state is correct
          if (_isFocused) {
            _updateOverlay();
          }
        },
        // autovalidateMode: widget.autovalidateMode, // TextField doesn't have autovalidateMode directly, usually for FormField
      ),
    );
  }
}