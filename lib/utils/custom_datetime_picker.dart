library date_range_picker;

import 'package:flutter/material.dart';

// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:penjualan/utils/custom_date_range_picker.dart'
    as DateRangePicker;

class CustomDateRangePicker {
  static show({
    required context,
    required DateTime initialFirstdate,
    required DateTime initialLastDate,
    required DateTime firstDate,
    required DateTime lastDate,
    bool clearToLastDate = false,
  }) async {
    return await DateRangePicker.showDatePicker(
      context: context,
      initialFirstDate: initialFirstdate,
      initialLastDate: initialLastDate,
      firstDate: firstDate,
      lastDate: lastDate,
      clearToLastDate: clearToLastDate,
      locale: Locale('id', 'ID,'),
    );
  }
}
