import 'dart:io';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/day_data.dart';
import '../style/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/backup_button.dart';
import '../widgets/info_row.dart';
import '../widgets/notification_toggle.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Constants.getHeight(context);

    Future<void> export() async {
      try {
        final dayData = Provider.of<DayData>(context, listen: false);
        final jsonString = await dayData.exportAsJson();

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/mood_backup.json');

        await tempFile.writeAsString(jsonString);

        final mediaStore = MediaStore();

        await mediaStore.saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup saved to Downloads')),
        );
      } catch (e) {
        debugPrint('EXPORT ERROR: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export backup')),
        );
      }
    }

    Future<void> import() async {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json'],
        );

        if (result == null) return;

        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();

        await context.read<DayData>().importFromJson(jsonString);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup imported successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid or corrupted backup file')),
        );
      }
    }

    void _showBackupInfo(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Backup & Restore',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                InfoRow(
                  icon: Icon(
                    Icons.download,
                    color: AppColors.background,
                  ),
                  title: 'Export Backup',
                  text:
                  'Exports all your mood data into a JSON file and saves it to your Downloads folder.',
                ),

                InfoRow(
                  icon: Icon(
                    Icons.folder,
                    color: AppColors.background,
                  ),
                  title: 'File Location',
                  text:
                  'Files → Downloads → mood_backup.json',
                ),

                InfoRow(
                  icon: Icon(
                    Icons.upload,
                    color: AppColors.background,
                  ),
                  title: 'Import Backup',
                  text:
                  'Select a previously exported JSON file to restore your data.',
                ),

                InfoRow(
                  icon: Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.background,
                  ),
                  title: 'Important',
                  text:
                  'Importing a backup will overwrite your current data. This action cannot be undone.',
                  isWarning: true,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }


    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        child: SizedBox(
          height: screenHeight * 0.45, // 30% of screen
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NotificationToggle(),
              const SizedBox(height: 16),
              BackupButton(
                label: 'Export Backup',
                onPressed: export,
              ),
              BackupButton(
                label: 'Import Backup',
                isDanger: true,
                onPressed: import,
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showBackupInfo(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSettingsPanel(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    barrierColor: Colors.black.withOpacity(0.4), // transparent overlay
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink(); // required, actual UI in transitionBuilder
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, -1), // from top
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      return SlideTransition(
        position: slide,
        child: const SettingsPanel(),
      );
    },
  );
}
