import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:bouncy/controllers/sensordatacontroller.dart';
import 'package:bouncy/models/sensordata.dart';

class Datatablescreen extends StatefulWidget {
  const Datatablescreen({super.key});

  @override
  State<Datatablescreen> createState() => _DatatablescreenState();
}

class _DatatablescreenState extends State<Datatablescreen> {
  static const _pageSize = 30;  // Number of items to load per page.
  late final Sensordatacontroller _sensordatacontroller;

  // Paging controller that manages pagination of the sensor data.
  late final PagingController<int, Sensordata> _pagingController;

  @override
  void initState() {
    super.initState();
    _sensordatacontroller = Sensordatacontroller();

    // Initialize the PagingController with pagination configuration.
    _pagingController = PagingController<int, Sensordata>(
      getNextPageKey: (state) {
        // Logic to determine the next page key based on current data.
        final nextKey = (state.keys?.last ?? 0) + 1;
        final totalLoadedItems = state.items?.length ?? 0;
        final isLastPage = totalLoadedItems % _pageSize != 0; // Check if it's the last page.
        return isLastPage ? null : nextKey;
      },
      fetchPage: (pageKey) => _sensordatacontroller.fetchSensorData(pageKey, _pageSize),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  /// Helper function to format the timestamp into a readable string.
  String formatTimestamp(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(dateTime.hour);
    final minutes = twoDigits(dateTime.minute);
    final seconds = twoDigits(dateTime.second);
    return "$hours:$minutes:$seconds";  // Return the formatted time as HH:MM:SS.
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text('Sensor Data Table'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),  // Back button action to navigate to the previous screen.
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: PagingListener<int, Sensordata>(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) {
          return PagedListView<int, Sensordata>(
            state: state, // Current state of the pagination.
            fetchNextPage: fetchNextPage, // Callback to fetch the next page.
            builderDelegate: PagedChildBuilderDelegate<Sensordata>( // Delegate for building the child widget.
              itemBuilder: (context, item, index) {
                return Column(
                  children: [
                    if (index == 0) // Table headers only shown on the first page.
                      Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Row(
                          children: [
                            Expanded(child: Text('X', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp))),
                            Expanded(child: Text('Y', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp))),
                            Expanded(child: Text('Z', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp))),
                            Expanded(child: Text('Timestamp', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp))),
                          ],
                        ),
                      ),
                    // Table conten logic.
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0.h),
                      child: Row(
                        children: [
                          Expanded(child: Text(item.acex.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp),)),
                          Expanded(child: Text(item.acey.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp),)),
                          Expanded(child: Text(item.gyroz.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp),)),
                          Expanded(child: Text(formatTimestamp(item.timestamp), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp),)),
                        ],
                      ),
                    ),
                  ],
                );
              },
              // Build the "no more items" indicator when all pages are loaded.
              noMoreItemsIndicatorBuilder: (context) => const SizedBox.shrink(),
              // Build the "no items found" indicator when no data is available.
              noItemsFoundIndicatorBuilder: (context) => const Center(child: Text('No sensor data found.')),
            ),
          );
        },
      ),
    );
  }
}
