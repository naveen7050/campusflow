import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import 'package:campusflow/core/utils/url_helper.dart';

class PdfViewerView extends StatefulWidget {
  static const String routeName = '/pdf-viewer';

  final String title;
  final String pathOrUrl;

  const PdfViewerView({
    super.key,
    required this.title,
    required this.pathOrUrl,
  });

  @override
  State<PdfViewerView> createState() => _PdfViewerViewState();
}

class _PdfViewerViewState extends State<PdfViewerView> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  String? _errorMessage;

  bool get _isNetwork =>
      widget.pathOrUrl.startsWith('http://') ||
      widget.pathOrUrl.startsWith('https://');

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        backgroundColor: context.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: context.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_isNetwork)
            IconButton(
              icon: Icon(
                LucideIcons.externalLink,
                color: context.primaryAccent,
                size: 19,
              ),
              tooltip: 'Open in Browser',
              onPressed: () => UrlHelper.openUrl(context, widget.pathOrUrl),
            ),
          IconButton(
            icon: Icon(
              LucideIcons.zoomIn,
              color: context.textSecondary,
              size: 20,
            ),
            tooltip: 'Zoom In',
            onPressed: () {
              _pdfViewerController.zoomLevel =
                  (_pdfViewerController.zoomLevel + 0.25).clamp(1.0, 3.0);
            },
          ),
          IconButton(
            icon: Icon(
              LucideIcons.zoomOut,
              color: context.textSecondary,
              size: 20,
            ),
            tooltip: 'Zoom Out',
            onPressed: () {
              _pdfViewerController.zoomLevel =
                  (_pdfViewerController.zoomLevel - 0.25).clamp(1.0, 3.0);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.alertCircle,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Could not render document',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isNetwork)
                      ElevatedButton.icon(
                        icon: const Icon(LucideIcons.externalLink, size: 16),
                        label: const Text('Open External Link'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () =>
                            UrlHelper.openUrl(context, widget.pathOrUrl),
                      ),
                  ],
                ),
              ),
            )
          else if (_isNetwork)
            SfPdfViewer.network(
              widget.pathOrUrl,
              controller: _pdfViewerController,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              onDocumentLoaded: (details) {
                if (mounted) setState(() => _isLoading = false);
              },
              onDocumentLoadFailed: (details) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = details.description;
                  });
                }
              },
            )
          else
            SfPdfViewer.file(
              File(widget.pathOrUrl),
              controller: _pdfViewerController,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              onDocumentLoaded: (details) {
                if (mounted) setState(() => _isLoading = false);
              },
              onDocumentLoadFailed: (details) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _errorMessage = details.description;
                  });
                }
              },
            ),
          if (_isLoading && _errorMessage == null)
            Center(
              child: CircularProgressIndicator(
                color: context.primaryAccent,
              ),
            ),
        ],
      ),
    );
  }
}
