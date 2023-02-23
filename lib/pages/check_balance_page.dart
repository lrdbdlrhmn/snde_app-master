//import 'dart:convert';
//import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/services/api_service.dart';
//import 'package:snde/services/auth_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

class CheckBalancePage extends StatefulWidget {
  const CheckBalancePage({Key? key}) : super(key: key);

  @override
  CheckBalancePageState createState() => CheckBalancePageState();
}

class CheckBalancePageState extends State<CheckBalancePage> {
  final _formKey = GlobalKey<FormState>();

  String _code = '';
  bool _gettingBalance = false;
  bool _showingPdf = false;
  bool _showingPdfLoading = false;
  bool _hasBalance = false;
  bool _hasPdf = false;
  String name = '';
  String balance = '';
  String? doc;
  //String doc = '';

  Future<void> _checkBalance() async {
    setState(() {
      _gettingBalance = true;
      _hasBalance = false;
      _hasPdf = false;
      _showingPdf = false;
      _showingPdfLoading = false;
    });

    try {
      String username = 'newsndemobile';
      String password = 'yKAFP9hmZARNnCm';
      Map<String, String> headers = {
        //'api-key': 'XQd0e4n887CciZnk7h8Puo56sci26ay0cmy8DaRDesixelZvicRBgt2ZsPte',
        'authorization':
            'Basic ' + base64.encode(utf8.encode('$username:$password')),
        //'client-source': 'apis',
        //'app-v': appVersion,
        //'app-language-x': ApiService.language
      };
      http.Response response = await http.get(
          Uri.parse('$apiUrl/get-info-user?vref=$_code'),
          headers: headers);
      //final result = response.body;
      final codeResponse = response.statusCode;
      if (codeResponse == 200) {
        final result = json.decode(response.body);
        /*final res = result['result'];
        if (res['status'] != 'ok') {
        
            throw 'no balance';
        }
        */
        name = result['nom'];
        balance = "${result['solde']}";
      }
      //final res = await apiService.get('check_balance/$_code');
      _hasBalance = true;
      _gettingBalance = false;
      _showPdf();
    } catch (error) {
      showToast(t(context, 'no_result'));
    }

    setState(() {
      _gettingBalance = false;
    });
  }

  Future<String> _generateHtml() async {
    String html = """
        <!DOCTYPE html>
<html lang="ar" dir="rtl">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Invoice Pdf</title>
<style>
  @charset "UTF-8";
/*!
 * Bootstrap  v5.2.2 (https://getbootstrap.com/)
 * Copyright 2011-2022 The Bootstrap Authors
 * Copyright 2011-2022 Twitter, Inc.
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/main/LICENSE)
 */
:root {
  --bs-blue: #0d6efd;
  --bs-indigo: #6610f2;
  --bs-purple: #6f42c1;
  --bs-pink: #d63384;
  --bs-red: #dc3545;
  --bs-orange: #fd7e14;
  --bs-yellow: #ffc107;
  --bs-green: #198754;
  --bs-teal: #20c997;
  --bs-cyan: #0dcaf0;
  --bs-black: #000;
  --bs-white: #fff;
  --bs-gray: #6c757d;
  --bs-gray-dark: #343a40;
  --bs-gray-100: #f8f9fa;
  --bs-gray-200: #e9ecef;
  --bs-gray-300: #dee2e6;
  --bs-gray-400: #ced4da;
  --bs-gray-500: #adb5bd;
  --bs-gray-600: #6c757d;
  --bs-gray-700: #495057;
  --bs-gray-800: #343a40;
  --bs-gray-900: #212529;
  --bs-primary: #0d6efd;
  --bs-secondary: #6c757d;
  --bs-success: #198754;
  --bs-info: #0dcaf0;
  --bs-warning: #ffc107;
  --bs-danger: #dc3545;
  --bs-light: #f8f9fa;
  --bs-dark: #212529;
  --bs-primary-rgb: 13, 110, 253;
  --bs-secondary-rgb: 108, 117, 125;
  --bs-success-rgb: 25, 135, 84;
  --bs-info-rgb: 13, 202, 240;
  --bs-warning-rgb: 255, 193, 7;
  --bs-danger-rgb: 220, 53, 69;
  --bs-light-rgb: 248, 249, 250;
  --bs-dark-rgb: 33, 37, 41;
  --bs-white-rgb: 255, 255, 255;
  --bs-black-rgb: 0, 0, 0;
  --bs-body-color-rgb: 33, 37, 41;
  --bs-body-bg-rgb: 255, 255, 255;
  --bs-font-sans-serif: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", "Noto Sans", "Liberation Sans", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  --bs-font-monospace: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
  --bs-gradient: linear-gradient(180deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0));
  --bs-body-font-family: var(--bs-font-sans-serif);
  --bs-body-font-size: 1rem;
  --bs-body-font-weight: 400;
  --bs-body-line-height: 1.5;
  --bs-body-color: #212529;
  --bs-body-bg: #fff;
  --bs-border-width: 1px;
  --bs-border-style: solid;
  --bs-border-color: #dee2e6;
  --bs-border-color-translucent: rgba(0, 0, 0, 0.175);
  --bs-border-radius: 0.375rem;
  --bs-border-radius-sm: 0.25rem;
  --bs-border-radius-lg: 0.5rem;
  --bs-border-radius-xl: 1rem;
  --bs-border-radius-2xl: 2rem;
  --bs-border-radius-pill: 50rem;
  --bs-link-color: #0d6efd;
  --bs-link-hover-color: #0a58ca;
  --bs-code-color: #d63384;
  --bs-highlight-bg: #fff3cd;
}

*,
*::before,
*::after {
  box-sizing: border-box;
}

@media (prefers-reduced-motion: no-preference) {
  :root {
    scroll-behavior: smooth;
  }
}

body {
  margin: 0;
  font-family: var(--bs-body-font-family);
  font-size: var(--bs-body-font-size);
  font-weight: var(--bs-body-font-weight);
  line-height: var(--bs-body-line-height);
  color: var(--bs-body-color);
  text-align: var(--bs-body-text-align);
  background-color: var(--bs-body-bg);
  -webkit-text-size-adjust: 100%;
  -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}

hr {
  margin: 1rem 0;
  color: inherit;
  border: 0;
  border-top: 1px solid;
  opacity: 0.25;
}

h6, .h6, h5, .h5, h4, .h4, h3, .h3, h2, .h2, h1, .h1 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  font-weight: 500;
  line-height: 1.2;
}

h1, .h1 {
  font-size: calc(1.375rem + 1.5vw);
}
@media (min-width: 1200px) {
  h1, .h1 {
    font-size: 2.5rem;
  }
}

h2, .h2 {
  font-size: calc(1.325rem + 0.9vw);
}
@media (min-width: 1200px) {
  h2, .h2 {
    font-size: 2rem;
  }
}

h3, .h3 {
  font-size: calc(1.3rem + 0.6vw);
}
@media (min-width: 1200px) {
  h3, .h3 {
    font-size: 1.75rem;
  }
}

h4, .h4 {
  font-size: calc(1.275rem + 0.3vw);
}
@media (min-width: 1200px) {
  h4, .h4 {
    font-size: 1.5rem;
  }
}

h5, .h5 {
  font-size: 1.25rem;
}

h6, .h6 {
  font-size: 1rem;
}

p {
  margin-top: 0;
  margin-bottom: 1rem;
}

abbr[title] {
  -webkit-text-decoration: underline dotted;
  text-decoration: underline dotted;
  cursor: help;
  -webkit-text-decoration-skip-ink: none;
  text-decoration-skip-ink: none;
}

address {
  margin-bottom: 1rem;
  font-style: normal;
  line-height: inherit;
}

ol,
ul {
  padding-left: 2rem;
}

ol,
ul,
dl {
  margin-top: 0;
  margin-bottom: 1rem;
}

ol ol,
ul ul,
ol ul,
ul ol {
  margin-bottom: 0;
}

dt {
  font-weight: 700;
}

dd {
  margin-bottom: 0.5rem;
  margin-left: 0;
}

blockquote {
  margin: 0 0 1rem;
}

b,
strong {
  font-weight: bolder;
}

small, .small {
  font-size: 0.875em;
}

mark, .mark {
  padding: 0.1875em;
  background-color: var(--bs-highlight-bg);
}

sub,
sup {
  position: relative;
  font-size: 0.75em;
  line-height: 0;
  vertical-align: baseline;
}

sub {
  bottom: -0.25em;
}

sup {
  top: -0.5em;
}

a {
  color: var(--bs-link-color);
  text-decoration: underline;
}
a:hover {
  color: var(--bs-link-hover-color);
}

a:not([href]):not([class]), a:not([href]):not([class]):hover {
  color: inherit;
  text-decoration: none;
}

pre,
code,
kbd,
samp {
  font-family: var(--bs-font-monospace);
  font-size: 1em;
}

pre {
  display: block;
  margin-top: 0;
  margin-bottom: 1rem;
  overflow: auto;
  font-size: 0.875em;
}
pre code {
  font-size: inherit;
  color: inherit;
  word-break: normal;
}

code {
  font-size: 0.875em;
  color: var(--bs-code-color);
  word-wrap: break-word;
}
a > code {
  color: inherit;
}

kbd {
  padding: 0.1875rem 0.375rem;
  font-size: 0.875em;
  color: var(--bs-body-bg);
  background-color: var(--bs-body-color);
  border-radius: 0.25rem;
}
kbd kbd {
  padding: 0;
  font-size: 1em;
}

figure {
  margin: 0 0 1rem;
}

img,
svg {
  vertical-align: middle;
}

table {
  caption-side: bottom;
  border-collapse: collapse;
}

caption {
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
  color: #6c757d;
  text-align: left;
}

th {
  text-align: inherit;
  text-align: -webkit-match-parent;
}

thead,
tbody,
tfoot,
tr,
td,
th {
  border-color: inherit;
  border-style: solid;
  border-width: 0;
}

label {
  display: inline-block;
}

button {
  border-radius: 0;
}

button:focus:not(:focus-visible) {
  outline: 0;
}

input,
button,
select,
optgroup,
textarea {
  margin: 0;
  font-family: inherit;
  font-size: inherit;
  line-height: inherit;
}

button,
select {
  text-transform: none;
}

[role=button] {
  cursor: pointer;
}

select {
  word-wrap: normal;
}
select:disabled {
  opacity: 1;
}

[list]:not([type=date]):not([type=datetime-local]):not([type=month]):not([type=week]):not([type=time])::-webkit-calendar-picker-indicator {
  display: none !important;
}

button,
[type=button],
[type=reset],
[type=submit] {
  -webkit-appearance: button;
}
button:not(:disabled),
[type=button]:not(:disabled),
[type=reset]:not(:disabled),
[type=submit]:not(:disabled) {
  cursor: pointer;
}

::-moz-focus-inner {
  padding: 0;
  border-style: none;
}

textarea {
  resize: vertical;
}

fieldset {
  min-width: 0;
  padding: 0;
  margin: 0;
  border: 0;
}

legend {
  float: left;
  width: 100%;
  padding: 0;
  margin-bottom: 0.5rem;
  font-size: calc(1.275rem + 0.3vw);
  line-height: inherit;
}
@media (min-width: 1200px) {
  legend {
    font-size: 1.5rem;
  }
}
legend + * {
  clear: left;
}

::-webkit-datetime-edit-fields-wrapper,
::-webkit-datetime-edit-text,
::-webkit-datetime-edit-minute,
::-webkit-datetime-edit-hour-field,
::-webkit-datetime-edit-day-field,
::-webkit-datetime-edit-month-field,
::-webkit-datetime-edit-year-field {
  padding: 0;
}

::-webkit-inner-spin-button {
  height: auto;
}

[type=search] {
  outline-offset: -2px;
  -webkit-appearance: textfield;
}

/* rtl:raw:
[type="tel"],
[type="url"],
[type="email"],
[type="number"] {
  direction: ltr;
}
*/
::-webkit-search-decoration {
  -webkit-appearance: none;
}

::-webkit-color-swatch-wrapper {
  padding: 0;
}

::-webkit-file-upload-button {
  font: inherit;
  -webkit-appearance: button;
}

::file-selector-button {
  font: inherit;
  -webkit-appearance: button;
}

output {
  display: inline-block;
}

iframe {
  border: 0;
}

summary {
  display: list-item;
  cursor: pointer;
}

progress {
  vertical-align: baseline;
}

[hidden] {
  display: none !important;
}

.lead {
  font-size: 1.25rem;
  font-weight: 300;
}

.display-1 {
  font-size: calc(1.625rem + 4.5vw);
  font-weight: 300;
  line-height: 1.2;
}
@media (min-width: 1200px) {
  .display-1 {
    font-size: 5rem;
  }
}

.display-2 {
  font-size: calc(1.575rem + 3.9vw);
  font-weight: 300;
  line-height: 1.2;
}
@media (min-width: 1200px) {
  .display-2 {
    font-size: 4.5rem;
  }
}

.display-3 {
  font-size: calc(1.525rem + 3.3vw);
  font-weight: 300;
  line-height: 1.2;
}
@media (min-width: 1200px) {
  .display-3 {
    font-size: 4rem;
  }
}

.display-4 {
  font-size: calc(1.475rem + 2.7vw);
  font-weight: 300;
  line-height: 1.2;
}
@media (min-width: 1200px) {
  .display-4 {
    font-size: 3.5rem;
  }
}

.display-5 {
  font-size: calc(1.425rem + 2.1vw);
  font-weight: 300;
  line-height: 1.2;
}
@media (min-width: 1200px) {
  .display-5 {
    font-size: 3rem;
  }
}

.display-6 {
  font-size: calc(1.375rem + 1.5vw);
  font-weight: 300;
  line-height: 1.2;
}
@media (min-width: 1200px) {
  .display-6 {
    font-size: 2.5rem;
  }
}

.list-unstyled {
  padding-left: 0;
  list-style: none;
}

.list-inline {
  padding-left: 0;
  list-style: none;
}

.list-inline-item {
  display: inline-block;
}
.list-inline-item:not(:last-child) {
  margin-right: 0.5rem;
}

.initialism {
  font-size: 0.875em;
  text-transform: uppercase;
}

.blockquote {
  margin-bottom: 1rem;
  font-size: 1.25rem;
}
.blockquote > :last-child {
  margin-bottom: 0;
}

.blockquote-footer {
  margin-top: -1rem;
  margin-bottom: 1rem;
  font-size: 0.875em;
  color: #6c757d;
}
.blockquote-footer::before {
  content: "— ";
}

.img-fluid {
  max-width: 100%;
  height: auto;
}

.img-thumbnail {
  padding: 0.25rem;
  background-color: #fff;
  border: 1px solid var(--bs-border-color);
  border-radius: 0.375rem;
  max-width: 100%;
  height: auto;
}

.figure {
  display: inline-block;
}

.figure-img {
  margin-bottom: 0.5rem;
  line-height: 1;
}

.figure-caption {
  font-size: 0.875em;
  color: #6c757d;
}

.container,
.container-fluid,
.container-xxl,
.container-xl,
.container-lg,
.container-md,
.container-sm {
  --bs-gutter-x: 1.5rem;
  --bs-gutter-y: 0;
  width: 100%;
  padding-right: calc(var(--bs-gutter-x) * 0.5);
  padding-left: calc(var(--bs-gutter-x) * 0.5);
  margin-right: auto;
  margin-left: auto;
}

@media (min-width: 576px) {
  .container-sm, .container {
    max-width: 540px;
  }
}
@media (min-width: 768px) {
  .container-md, .container-sm, .container {
    max-width: 720px;
  }
}
@media (min-width: 992px) {
  .container-lg, .container-md, .container-sm, .container {
    max-width: 960px;
  }
}
@media (min-width: 1200px) {
  .container-xl, .container-lg, .container-md, .container-sm, .container {
    max-width: 1140px;
  }
}
@media (min-width: 1400px) {
  .container-xxl, .container-xl, .container-lg, .container-md, .container-sm, .container {
    max-width: 1320px;
  }
}
.row {
  --bs-gutter-x: 1.5rem;
  --bs-gutter-y: 0;
  display: flex;
  flex-wrap: wrap;
  margin-top: calc(-1 * var(--bs-gutter-y));
  margin-right: calc(-0.5 * var(--bs-gutter-x));
  margin-left: calc(-0.5 * var(--bs-gutter-x));
}
.row > * {
  flex-shrink: 0;
  width: 100%;
  max-width: 100%;
  padding-right: calc(var(--bs-gutter-x) * 0.5);
  padding-left: calc(var(--bs-gutter-x) * 0.5);
  margin-top: var(--bs-gutter-y);
}

.col {
  flex: 1 0 0%;
}

.row-cols-auto > * {
  flex: 0 0 auto;
  width: auto;
}

.row-cols-1 > * {
  flex: 0 0 auto;
  width: 100%;
}

.row-cols-2 > * {
  flex: 0 0 auto;
  width: 50%;
}

.row-cols-3 > * {
  flex: 0 0 auto;
  width: 33.3333333333%;
}

.row-cols-4 > * {
  flex: 0 0 auto;
  width: 25%;
}

.row-cols-5 > * {
  flex: 0 0 auto;
  width: 20%;
}

.row-cols-6 > * {
  flex: 0 0 auto;
  width: 16.6666666667%;
}

.col-auto {
  flex: 0 0 auto;
  width: auto;
}

.col-1 {
  flex: 0 0 auto;
  width: 8.33333333%;
}

.col-2 {
  flex: 0 0 auto;
  width: 16.66666667%;
}

.col-3 {
  flex: 0 0 auto;
  width: 25%;
}

.col-4 {
  flex: 0 0 auto;
  width: 33.33333333%;
}

.col-5 {
  flex: 0 0 auto;
  width: 41.66666667%;
}

.col-6 {
  flex: 0 0 auto;
  width: 50%;
}

.col-7 {
  flex: 0 0 auto;
  width: 58.33333333%;
}

.col-8 {
  flex: 0 0 auto;
  width: 66.66666667%;
}

.col-9 {
  flex: 0 0 auto;
  width: 75%;
}

.col-10 {
  flex: 0 0 auto;
  width: 83.33333333%;
}

.col-11 {
  flex: 0 0 auto;
  width: 91.66666667%;
}

.col-12 {
  flex: 0 0 auto;
  width: 100%;
}

.offset-1 {
  margin-left: 8.33333333%;
}

.offset-2 {
  margin-left: 16.66666667%;
}

.offset-3 {
  margin-left: 25%;
}

.offset-4 {
  margin-left: 33.33333333%;
}

.offset-5 {
  margin-left: 41.66666667%;
}

.offset-6 {
  margin-left: 50%;
}

.offset-7 {
  margin-left: 58.33333333%;
}

.offset-8 {
  margin-left: 66.66666667%;
}

.offset-9 {
  margin-left: 75%;
}

.offset-10 {
  margin-left: 83.33333333%;
}

.offset-11 {
  margin-left: 91.66666667%;
}

.g-0,
.gx-0 {
  --bs-gutter-x: 0;
}

.g-0,
.gy-0 {
  --bs-gutter-y: 0;
}

.g-1,
.gx-1 {
  --bs-gutter-x: 0.25rem;
}

.g-1,
.gy-1 {
  --bs-gutter-y: 0.25rem;
}

.g-2,
.gx-2 {
  --bs-gutter-x: 0.5rem;
}

.g-2,
.gy-2 {
  --bs-gutter-y: 0.5rem;
}

.g-3,
.gx-3 {
  --bs-gutter-x: 1rem;
}

.g-3,
.gy-3 {
  --bs-gutter-y: 1rem;
}

.g-4,
.gx-4 {
  --bs-gutter-x: 1.5rem;
}

.g-4,
.gy-4 {
  --bs-gutter-y: 1.5rem;
}

.g-5,
.gx-5 {
  --bs-gutter-x: 3rem;
}

.g-5,
.gy-5 {
  --bs-gutter-y: 3rem;
}

@media (min-width: 576px) {
  .col-sm {
    flex: 1 0 0%;
  }
  .row-cols-sm-auto > * {
    flex: 0 0 auto;
    width: auto;
  }
  .row-cols-sm-1 > * {
    flex: 0 0 auto;
    width: 100%;
  }
  .row-cols-sm-2 > * {
    flex: 0 0 auto;
    width: 50%;
  }
  .row-cols-sm-3 > * {
    flex: 0 0 auto;
    width: 33.3333333333%;
  }
  .row-cols-sm-4 > * {
    flex: 0 0 auto;
    width: 25%;
  }
  .row-cols-sm-5 > * {
    flex: 0 0 auto;
    width: 20%;
  }
  .row-cols-sm-6 > * {
    flex: 0 0 auto;
    width: 16.6666666667%;
  }
  .col-sm-auto {
    flex: 0 0 auto;
    width: auto;
  }
  .col-sm-1 {
    flex: 0 0 auto;
    width: 8.33333333%;
  }
  .col-sm-2 {
    flex: 0 0 auto;
    width: 16.66666667%;
  }
  .col-sm-3 {
    flex: 0 0 auto;
    width: 25%;
  }
  .col-sm-4 {
    flex: 0 0 auto;
    width: 33.33333333%;
  }
  .col-sm-5 {
    flex: 0 0 auto;
    width: 41.66666667%;
  }
  .col-sm-6 {
    flex: 0 0 auto;
    width: 50%;
  }
  .col-sm-7 {
    flex: 0 0 auto;
    width: 58.33333333%;
  }
  .col-sm-8 {
    flex: 0 0 auto;
    width: 66.66666667%;
  }
  .col-sm-9 {
    flex: 0 0 auto;
    width: 75%;
  }
  .col-sm-10 {
    flex: 0 0 auto;
    width: 83.33333333%;
  }
  .col-sm-11 {
    flex: 0 0 auto;
    width: 91.66666667%;
  }
  .col-sm-12 {
    flex: 0 0 auto;
    width: 100%;
  }
  .offset-sm-0 {
    margin-left: 0;
  }
  .offset-sm-1 {
    margin-left: 8.33333333%;
  }
  .offset-sm-2 {
    margin-left: 16.66666667%;
  }
  .offset-sm-3 {
    margin-left: 25%;
  }
  .offset-sm-4 {
    margin-left: 33.33333333%;
  }
  .offset-sm-5 {
    margin-left: 41.66666667%;
  }
  .offset-sm-6 {
    margin-left: 50%;
  }
  .offset-sm-7 {
    margin-left: 58.33333333%;
  }
  .offset-sm-8 {
    margin-left: 66.66666667%;
  }
  .offset-sm-9 {
    margin-left: 75%;
  }
  .offset-sm-10 {
    margin-left: 83.33333333%;
  }
  .offset-sm-11 {
    margin-left: 91.66666667%;
  }
  .g-sm-0,
.gx-sm-0 {
    --bs-gutter-x: 0;
  }
  .g-sm-0,
.gy-sm-0 {
    --bs-gutter-y: 0;
  }
  .g-sm-1,
.gx-sm-1 {
    --bs-gutter-x: 0.25rem;
  }
  .g-sm-1,
.gy-sm-1 {
    --bs-gutter-y: 0.25rem;
  }
  .g-sm-2,
.gx-sm-2 {
    --bs-gutter-x: 0.5rem;
  }
  .g-sm-2,
.gy-sm-2 {
    --bs-gutter-y: 0.5rem;
  }
  .g-sm-3,
.gx-sm-3 {
    --bs-gutter-x: 1rem;
  }
  .g-sm-3,
.gy-sm-3 {
    --bs-gutter-y: 1rem;
  }
  .g-sm-4,
.gx-sm-4 {
    --bs-gutter-x: 1.5rem;
  }
  .g-sm-4,
.gy-sm-4 {
    --bs-gutter-y: 1.5rem;
  }
  .g-sm-5,
.gx-sm-5 {
    --bs-gutter-x: 3rem;
  }
  .g-sm-5,
.gy-sm-5 {
    --bs-gutter-y: 3rem;
  }
}
@media (min-width: 768px) {
  .col-md {
    flex: 1 0 0%;
  }
  .row-cols-md-auto > * {
    flex: 0 0 auto;
    width: auto;
  }
  .row-cols-md-1 > * {
    flex: 0 0 auto;
    width: 100%;
  }
  .row-cols-md-2 > * {
    flex: 0 0 auto;
    width: 50%;
  }
  .row-cols-md-3 > * {
    flex: 0 0 auto;
    width: 33.3333333333%;
  }
  .row-cols-md-4 > * {
    flex: 0 0 auto;
    width: 25%;
  }
  .row-cols-md-5 > * {
    flex: 0 0 auto;
    width: 20%;
  }
  .row-cols-md-6 > * {
    flex: 0 0 auto;
    width: 16.6666666667%;
  }
  .col-md-auto {
    flex: 0 0 auto;
    width: auto;
  }
  .col-md-1 {
    flex: 0 0 auto;
    width: 8.33333333%;
  }
  .col-md-2 {
    flex: 0 0 auto;
    width: 16.66666667%;
  }
  .col-md-3 {
    flex: 0 0 auto;
    width: 25%;
  }
  .col-md-4 {
    flex: 0 0 auto;
    width: 33.33333333%;
  }
  .col-md-5 {
    flex: 0 0 auto;
    width: 41.66666667%;
  }
  .col-md-6 {
    flex: 0 0 auto;
    width: 50%;
  }
  .col-md-7 {
    flex: 0 0 auto;
    width: 58.33333333%;
  }
  .col-md-8 {
    flex: 0 0 auto;
    width: 66.66666667%;
  }
  .col-md-9 {
    flex: 0 0 auto;
    width: 75%;
  }
  .col-md-10 {
    flex: 0 0 auto;
    width: 83.33333333%;
  }
  .col-md-11 {
    flex: 0 0 auto;
    width: 91.66666667%;
  }
  .col-md-12 {
    flex: 0 0 auto;
    width: 100%;
  }
  .offset-md-0 {
    margin-left: 0;
  }
  .offset-md-1 {
    margin-left: 8.33333333%;
  }
  .offset-md-2 {
    margin-left: 16.66666667%;
  }
  .offset-md-3 {
    margin-left: 25%;
  }
  .offset-md-4 {
    margin-left: 33.33333333%;
  }
  .offset-md-5 {
    margin-left: 41.66666667%;
  }
  .offset-md-6 {
    margin-left: 50%;
  }
  .offset-md-7 {
    margin-left: 58.33333333%;
  }
  .offset-md-8 {
    margin-left: 66.66666667%;
  }
  .offset-md-9 {
    margin-left: 75%;
  }
  .offset-md-10 {
    margin-left: 83.33333333%;
  }
  .offset-md-11 {
    margin-left: 91.66666667%;
  }
  .g-md-0,
.gx-md-0 {
    --bs-gutter-x: 0;
  }
  .g-md-0,
.gy-md-0 {
    --bs-gutter-y: 0;
  }
  .g-md-1,
.gx-md-1 {
    --bs-gutter-x: 0.25rem;
  }
  .g-md-1,
.gy-md-1 {
    --bs-gutter-y: 0.25rem;
  }
  .g-md-2,
.gx-md-2 {
    --bs-gutter-x: 0.5rem;
  }
  .g-md-2,
.gy-md-2 {
    --bs-gutter-y: 0.5rem;
  }
  .g-md-3,
.gx-md-3 {
    --bs-gutter-x: 1rem;
  }
  .g-md-3,
.gy-md-3 {
    --bs-gutter-y: 1rem;
  }
  .g-md-4,
.gx-md-4 {
    --bs-gutter-x: 1.5rem;
  }
  .g-md-4,
.gy-md-4 {
    --bs-gutter-y: 1.5rem;
  }
  .g-md-5,
.gx-md-5 {
    --bs-gutter-x: 3rem;
  }
  .g-md-5,
.gy-md-5 {
    --bs-gutter-y: 3rem;
  }
}
@media (min-width: 992px) {
  .col-lg {
    flex: 1 0 0%;
  }
  .row-cols-lg-auto > * {
    flex: 0 0 auto;
    width: auto;
  }
  .row-cols-lg-1 > * {
    flex: 0 0 auto;
    width: 100%;
  }
  .row-cols-lg-2 > * {
    flex: 0 0 auto;
    width: 50%;
  }
  .row-cols-lg-3 > * {
    flex: 0 0 auto;
    width: 33.3333333333%;
  }
  .row-cols-lg-4 > * {
    flex: 0 0 auto;
    width: 25%;
  }
  .row-cols-lg-5 > * {
    flex: 0 0 auto;
    width: 20%;
  }
  .row-cols-lg-6 > * {
    flex: 0 0 auto;
    width: 16.6666666667%;
  }
  .col-lg-auto {
    flex: 0 0 auto;
    width: auto;
  }
  .col-lg-1 {
    flex: 0 0 auto;
    width: 8.33333333%;
  }
  .col-lg-2 {
    flex: 0 0 auto;
    width: 16.66666667%;
  }
  .col-lg-3 {
    flex: 0 0 auto;
    width: 25%;
  }
  .col-lg-4 {
    flex: 0 0 auto;
    width: 33.33333333%;
  }
  .col-lg-5 {
    flex: 0 0 auto;
    width: 41.66666667%;
  }
  .col-lg-6 {
    flex: 0 0 auto;
    width: 50%;
  }
  .col-lg-7 {
    flex: 0 0 auto;
    width: 58.33333333%;
  }
  .col-lg-8 {
    flex: 0 0 auto;
    width: 66.66666667%;
  }
  .col-lg-9 {
    flex: 0 0 auto;
    width: 75%;
  }
  .col-lg-10 {
    flex: 0 0 auto;
    width: 83.33333333%;
  }
  .col-lg-11 {
    flex: 0 0 auto;
    width: 91.66666667%;
  }
  .col-lg-12 {
    flex: 0 0 auto;
    width: 100%;
  }
  .offset-lg-0 {
    margin-left: 0;
  }
  .offset-lg-1 {
    margin-left: 8.33333333%;
  }
  .offset-lg-2 {
    margin-left: 16.66666667%;
  }
  .offset-lg-3 {
    margin-left: 25%;
  }
  .offset-lg-4 {
    margin-left: 33.33333333%;
  }
  .offset-lg-5 {
    margin-left: 41.66666667%;
  }
  .offset-lg-6 {
    margin-left: 50%;
  }
  .offset-lg-7 {
    margin-left: 58.33333333%;
  }
  .offset-lg-8 {
    margin-left: 66.66666667%;
  }
  .offset-lg-9 {
    margin-left: 75%;
  }
  .offset-lg-10 {
    margin-left: 83.33333333%;
  }
  .offset-lg-11 {
    margin-left: 91.66666667%;
  }
  .g-lg-0,
.gx-lg-0 {
    --bs-gutter-x: 0;
  }
  .g-lg-0,
.gy-lg-0 {
    --bs-gutter-y: 0;
  }
  .g-lg-1,
.gx-lg-1 {
    --bs-gutter-x: 0.25rem;
  }
  .g-lg-1,
.gy-lg-1 {
    --bs-gutter-y: 0.25rem;
  }
  .g-lg-2,
.gx-lg-2 {
    --bs-gutter-x: 0.5rem;
  }
  .g-lg-2,
.gy-lg-2 {
    --bs-gutter-y: 0.5rem;
  }
  .g-lg-3,
.gx-lg-3 {
    --bs-gutter-x: 1rem;
  }
  .g-lg-3,
.gy-lg-3 {
    --bs-gutter-y: 1rem;
  }
  .g-lg-4,
.gx-lg-4 {
    --bs-gutter-x: 1.5rem;
  }
  .g-lg-4,
.gy-lg-4 {
    --bs-gutter-y: 1.5rem;
  }
  .g-lg-5,
.gx-lg-5 {
    --bs-gutter-x: 3rem;
  }
  .g-lg-5,
.gy-lg-5 {
    --bs-gutter-y: 3rem;
  }
}
@media (min-width: 1200px) {
  .col-xl {
    flex: 1 0 0%;
  }
  .row-cols-xl-auto > * {
    flex: 0 0 auto;
    width: auto;
  }
  .row-cols-xl-1 > * {
    flex: 0 0 auto;
    width: 100%;
  }
  .row-cols-xl-2 > * {
    flex: 0 0 auto;
    width: 50%;
  }
  .row-cols-xl-3 > * {
    flex: 0 0 auto;
    width: 33.3333333333%;
  }
  .row-cols-xl-4 > * {
    flex: 0 0 auto;
    width: 25%;
  }
  .row-cols-xl-5 > * {
    flex: 0 0 auto;
    width: 20%;
  }
  .row-cols-xl-6 > * {
    flex: 0 0 auto;
    width: 16.6666666667%;
  }
  .col-xl-auto {
    flex: 0 0 auto;
    width: auto;
  }
  .col-xl-1 {
    flex: 0 0 auto;
    width: 8.33333333%;
  }
  .col-xl-2 {
    flex: 0 0 auto;
    width: 16.66666667%;
  }
  .col-xl-3 {
    flex: 0 0 auto;
    width: 25%;
  }
  .col-xl-4 {
    flex: 0 0 auto;
    width: 33.33333333%;
  }
  .col-xl-5 {
    flex: 0 0 auto;
    width: 41.66666667%;
  }
  .col-xl-6 {
    flex: 0 0 auto;
    width: 50%;
  }
  .col-xl-7 {
    flex: 0 0 auto;
    width: 58.33333333%;
  }
  .col-xl-8 {
    flex: 0 0 auto;
    width: 66.66666667%;
  }
  .col-xl-9 {
    flex: 0 0 auto;
    width: 75%;
  }
  .col-xl-10 {
    flex: 0 0 auto;
    width: 83.33333333%;
  }
  .col-xl-11 {
    flex: 0 0 auto;
    width: 91.66666667%;
  }
  .col-xl-12 {
    flex: 0 0 auto;
    width: 100%;
  }
  .offset-xl-0 {
    margin-left: 0;
  }
  .offset-xl-1 {
    margin-left: 8.33333333%;
  }
  .offset-xl-2 {
    margin-left: 16.66666667%;
  }
  .offset-xl-3 {
    margin-left: 25%;
  }
  .offset-xl-4 {
    margin-left: 33.33333333%;
  }
  .offset-xl-5 {
    margin-left: 41.66666667%;
  }
  .offset-xl-6 {
    margin-left: 50%;
  }
  .offset-xl-7 {
    margin-left: 58.33333333%;
  }
  .offset-xl-8 {
    margin-left: 66.66666667%;
  }
  .offset-xl-9 {
    margin-left: 75%;
  }
  .offset-xl-10 {
    margin-left: 83.33333333%;
  }
  .offset-xl-11 {
    margin-left: 91.66666667%;
  }
  .g-xl-0,
.gx-xl-0 {
    --bs-gutter-x: 0;
  }
  .g-xl-0,
.gy-xl-0 {
    --bs-gutter-y: 0;
  }
  .g-xl-1,
.gx-xl-1 {
    --bs-gutter-x: 0.25rem;
  }
  .g-xl-1,
.gy-xl-1 {
    --bs-gutter-y: 0.25rem;
  }
  .g-xl-2,
.gx-xl-2 {
    --bs-gutter-x: 0.5rem;
  }
  .g-xl-2,
.gy-xl-2 {
    --bs-gutter-y: 0.5rem;
  }
  .g-xl-3,
.gx-xl-3 {
    --bs-gutter-x: 1rem;
  }
  .g-xl-3,
.gy-xl-3 {
    --bs-gutter-y: 1rem;
  }
  .g-xl-4,
.gx-xl-4 {
    --bs-gutter-x: 1.5rem;
  }
  .g-xl-4,
.gy-xl-4 {
    --bs-gutter-y: 1.5rem;
  }
  .g-xl-5,
.gx-xl-5 {
    --bs-gutter-x: 3rem;
  }
  .g-xl-5,
.gy-xl-5 {
    --bs-gutter-y: 3rem;
  }
}
@media (min-width: 1400px) {
  .col-xxl {
    flex: 1 0 0%;
  }
  .row-cols-xxl-auto > * {
    flex: 0 0 auto;
    width: auto;
  }
  .row-cols-xxl-1 > * {
    flex: 0 0 auto;
    width: 100%;
  }
  .row-cols-xxl-2 > * {
    flex: 0 0 auto;
    width: 50%;
  }
  .row-cols-xxl-3 > * {
    flex: 0 0 auto;
    width: 33.3333333333%;
  }
  .row-cols-xxl-4 > * {
    flex: 0 0 auto;
    width: 25%;
  }
  .row-cols-xxl-5 > * {
    flex: 0 0 auto;
    width: 20%;
  }
  .row-cols-xxl-6 > * {
    flex: 0 0 auto;
    width: 16.6666666667%;
  }
  .col-xxl-auto {
    flex: 0 0 auto;
    width: auto;
  }
  .col-xxl-1 {
    flex: 0 0 auto;
    width: 8.33333333%;
  }
  .col-xxl-2 {
    flex: 0 0 auto;
    width: 16.66666667%;
  }
  .col-xxl-3 {
    flex: 0 0 auto;
    width: 25%;
  }
  .col-xxl-4 {
    flex: 0 0 auto;
    width: 33.33333333%;
  }
  .col-xxl-5 {
    flex: 0 0 auto;
    width: 41.66666667%;
  }
  .col-xxl-6 {
    flex: 0 0 auto;
    width: 50%;
  }
  .col-xxl-7 {
    flex: 0 0 auto;
    width: 58.33333333%;
  }
  .col-xxl-8 {
    flex: 0 0 auto;
    width: 66.66666667%;
  }
  .col-xxl-9 {
    flex: 0 0 auto;
    width: 75%;
  }
  .col-xxl-10 {
    flex: 0 0 auto;
    width: 83.33333333%;
  }
  .col-xxl-11 {
    flex: 0 0 auto;
    width: 91.66666667%;
  }
  .col-xxl-12 {
    flex: 0 0 auto;
    width: 100%;
  }
  .offset-xxl-0 {
    margin-left: 0;
  }
  .offset-xxl-1 {
    margin-left: 8.33333333%;
  }
  .offset-xxl-2 {
    margin-left: 16.66666667%;
  }
  .offset-xxl-3 {
    margin-left: 25%;
  }
  .offset-xxl-4 {
    margin-left: 33.33333333%;
  }
  .offset-xxl-5 {
    margin-left: 41.66666667%;
  }
  .offset-xxl-6 {
    margin-left: 50%;
  }
  .offset-xxl-7 {
    margin-left: 58.33333333%;
  }
  .offset-xxl-8 {
    margin-left: 66.66666667%;
  }
  .offset-xxl-9 {
    margin-left: 75%;
  }
  .offset-xxl-10 {
    margin-left: 83.33333333%;
  }
  .offset-xxl-11 {
    margin-left: 91.66666667%;
  }
  .g-xxl-0,
.gx-xxl-0 {
    --bs-gutter-x: 0;
  }
  .g-xxl-0,
.gy-xxl-0 {
    --bs-gutter-y: 0;
  }
  .g-xxl-1,
.gx-xxl-1 {
    --bs-gutter-x: 0.25rem;
  }
  .g-xxl-1,
.gy-xxl-1 {
    --bs-gutter-y: 0.25rem;
  }
  .g-xxl-2,
.gx-xxl-2 {
    --bs-gutter-x: 0.5rem;
  }
  .g-xxl-2,
.gy-xxl-2 {
    --bs-gutter-y: 0.5rem;
  }
  .g-xxl-3,
.gx-xxl-3 {
    --bs-gutter-x: 1rem;
  }
  .g-xxl-3,
.gy-xxl-3 {
    --bs-gutter-y: 1rem;
  }
  .g-xxl-4,
.gx-xxl-4 {
    --bs-gutter-x: 1.5rem;
  }
  .g-xxl-4,
.gy-xxl-4 {
    --bs-gutter-y: 1.5rem;
  }
  .g-xxl-5,
.gx-xxl-5 {
    --bs-gutter-x: 3rem;
  }
  .g-xxl-5,
.gy-xxl-5 {
    --bs-gutter-y: 3rem;
  }
}
.table {
  --bs-table-color: var(--bs-body-color);
  --bs-table-bg: transparent;
  --bs-table-border-color: var(--bs-border-color);
  --bs-table-accent-bg: transparent;
  --bs-table-striped-color: var(--bs-body-color);
  --bs-table-striped-bg: rgba(0, 0, 0, 0.05);
  --bs-table-active-color: var(--bs-body-color);
  --bs-table-active-bg: rgba(0, 0, 0, 0.1);
  --bs-table-hover-color: var(--bs-body-color);
  --bs-table-hover-bg: rgba(0, 0, 0, 0.075);
  width: 100%;
  margin-bottom: 1rem;
  color: var(--bs-table-color);
  vertical-align: top;
  border-color: var(--bs-table-border-color);
}
.table > :not(caption) > * > * {
  padding: 0.5rem 0.5rem;
  background-color: var(--bs-table-bg);
  border-bottom-width: 1px;
  box-shadow: inset 0 0 0 9999px var(--bs-table-accent-bg);
}
.table > tbody {
  vertical-align: inherit;
}
.table > thead {
  vertical-align: bottom;
}

.table-group-divider {
  border-top: 2px solid currentcolor;
}

.caption-top {
  caption-side: top;
}

.table-sm > :not(caption) > * > * {
  padding: 0.25rem 0.25rem;
}

.table-bordered > :not(caption) > * {
  border-width: 1px 0;
}
.table-bordered > :not(caption) > * > * {
  border-width: 0 1px;
}

.table-borderless > :not(caption) > * > * {
  border-bottom-width: 0;
}
.table-borderless > :not(:first-child) {
  border-top-width: 0;
}

.table-striped > tbody > tr:nth-of-type(odd) > * {
  --bs-table-accent-bg: var(--bs-table-striped-bg);
  color: var(--bs-table-striped-color);
}

.table-striped-columns > :not(caption) > tr > :nth-child(even) {
  --bs-table-accent-bg: var(--bs-table-striped-bg);
  color: var(--bs-table-striped-color);
}

.table-active {
  --bs-table-accent-bg: var(--bs-table-active-bg);
  color: var(--bs-table-active-color);
}

.table-hover > tbody > tr:hover > * {
  --bs-table-accent-bg: var(--bs-table-hover-bg);
  color: var(--bs-table-hover-color);
}

.table-primary {
  --bs-table-color: #000;
  --bs-table-bg: #cfe2ff;
  --bs-table-border-color: #bacbe6;
  --bs-table-striped-bg: #c5d7f2;
  --bs-table-striped-color: #000;
  --bs-table-active-bg: #bacbe6;
  --bs-table-active-color: #000;
  --bs-table-hover-bg: #bfd1ec;
  --bs-table-hover-color: #000;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-secondary {
  --bs-table-color: #000;
  --bs-table-bg: #e2e3e5;
  --bs-table-border-color: #cbccce;
  --bs-table-striped-bg: #d7d8da;
  --bs-table-striped-color: #000;
  --bs-table-active-bg: #cbccce;
  --bs-table-active-color: #000;
  --bs-table-hover-bg: #d1d2d4;
  --bs-table-hover-color: #000;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-success {
  --bs-table-color: #000;
  --bs-table-bg: #d1e7dd;
  --bs-table-border-color: #bcd0c7;
  --bs-table-striped-bg: #c7dbd2;
  --bs-table-striped-color: #000;
  --bs-table-active-bg: #bcd0c7;
  --bs-table-active-color: #000;
  --bs-table-hover-bg: #c1d6cc;
  --bs-table-hover-color: #000;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-info {
  --bs-table-color: #000;
  --bs-table-bg: #cff4fc;
  --bs-table-border-color: #badce3;
  --bs-table-striped-bg: #c5e8ef;
  --bs-table-striped-color: #000;
  --bs-table-active-bg: #badce3;
  --bs-table-active-color: #000;
  --bs-table-hover-bg: #bfe2e9;
  --bs-table-hover-color: #000;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-warning {
  --bs-table-color: #000;
  --bs-table-bg: #fff3cd;
  --bs-table-border-color: #e6dbb9;
  --bs-table-striped-bg: #f2e7c3;
  --bs-table-striped-color: #000;
  --bs-table-active-bg: #e6dbb9;
  --bs-table-active-color: #000;
  --bs-table-hover-bg: #ece1be;
  --bs-table-hover-color: #000;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-danger {
  --bs-table-color: #000;
  --bs-table-bg: #f8d7da;
  --bs-table-border-color: #dfc2c4;
  --bs-table-striped-bg: #eccccf;
  --bs-table-striped-color: #000;
  --bs-table-active-bg: #dfc2c4;
  --bs-table-active-color: #000;
  --bs-table-hover-bg: #e5c7ca;
  --bs-table-hover-color: #000;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-light {
  --bs-table-color: #000;
  --bs-table-bg: #f8f9fa;
  --bs-table-border-color: #dfe0e1;
  --bs-table-striped-bg: #ecedee;
  --bs-table-striped-color: #000;
  --bs-table-active-bg: #dfe0e1;
  --bs-table-active-color: #000;
  --bs-table-hover-bg: #e5e6e7;
  --bs-table-hover-color: #000;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-dark {
  --bs-table-color: #fff;
  --bs-table-bg: #212529;
  --bs-table-border-color: #373b3e;
  --bs-table-striped-bg: #2c3034;
  --bs-table-striped-color: #fff;
  --bs-table-active-bg: #373b3e;
  --bs-table-active-color: #fff;
  --bs-table-hover-bg: #323539;
  --bs-table-hover-color: #fff;
  color: var(--bs-table-color);
  border-color: var(--bs-table-border-color);
}

.table-responsive {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

@media (max-width: 575.98px) {
  .table-responsive-sm {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }
}
@media (max-width: 767.98px) {
  .table-responsive-md {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }
}
@media (max-width: 991.98px) {
  .table-responsive-lg {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }
}
@media (max-width: 1199.98px) {
  .table-responsive-xl {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }
}
@media (max-width: 1399.98px) {
  .table-responsive-xxl {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }
}
.form-label {
  margin-bottom: 0.5rem;
}

.col-form-label {
  padding-top: calc(0.375rem + 1px);
  padding-bottom: calc(0.375rem + 1px);
  margin-bottom: 0;
  font-size: inherit;
  line-height: 1.5;
}

.col-form-label-lg {
  padding-top: calc(0.5rem + 1px);
  padding-bottom: calc(0.5rem + 1px);
  font-size: 1.25rem;
}

.col-form-label-sm {
  padding-top: calc(0.25rem + 1px);
  padding-bottom: calc(0.25rem + 1px);
  font-size: 0.875rem;
}

.form-text {
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #6c757d;
}

.form-control {
  display: block;
  width: 100%;
  padding: 0.375rem 0.75rem;
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
  color: #212529;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid #ced4da;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  border-radius: 0.375rem;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .form-control {
    transition: none;
  }
}
.form-control[type=file] {
  overflow: hidden;
}
.form-control[type=file]:not(:disabled):not([readonly]) {
  cursor: pointer;
}
.form-control:focus {
  color: #212529;
  background-color: #fff;
  border-color: #86b7fe;
  outline: 0;
  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}
.form-control::-webkit-date-and-time-value {
  height: 1.5em;
}
.form-control::-moz-placeholder {
  color: #6c757d;
  opacity: 1;
}
.form-control::placeholder {
  color: #6c757d;
  opacity: 1;
}
.form-control:disabled {
  background-color: #e9ecef;
  opacity: 1;
}
.form-control::-webkit-file-upload-button {
  padding: 0.375rem 0.75rem;
  margin: -0.375rem -0.75rem;
  -webkit-margin-end: 0.75rem;
  margin-inline-end: 0.75rem;
  color: #212529;
  background-color: #e9ecef;
  pointer-events: none;
  border-color: inherit;
  border-style: solid;
  border-width: 0;
  border-inline-end-width: 1px;
  border-radius: 0;
  -webkit-transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}
.form-control::file-selector-button {
  padding: 0.375rem 0.75rem;
  margin: -0.375rem -0.75rem;
  -webkit-margin-end: 0.75rem;
  margin-inline-end: 0.75rem;
  color: #212529;
  background-color: #e9ecef;
  pointer-events: none;
  border-color: inherit;
  border-style: solid;
  border-width: 0;
  border-inline-end-width: 1px;
  border-radius: 0;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .form-control::-webkit-file-upload-button {
    -webkit-transition: none;
    transition: none;
  }
  .form-control::file-selector-button {
    transition: none;
  }
}
.form-control:hover:not(:disabled):not([readonly])::-webkit-file-upload-button {
  background-color: #dde0e3;
}
.form-control:hover:not(:disabled):not([readonly])::file-selector-button {
  background-color: #dde0e3;
}

.form-control-plaintext {
  display: block;
  width: 100%;
  padding: 0.375rem 0;
  margin-bottom: 0;
  line-height: 1.5;
  color: #212529;
  background-color: transparent;
  border: solid transparent;
  border-width: 1px 0;
}
.form-control-plaintext:focus {
  outline: 0;
}
.form-control-plaintext.form-control-sm, .form-control-plaintext.form-control-lg {
  padding-right: 0;
  padding-left: 0;
}

.form-control-sm {
  min-height: calc(1.5em + 0.5rem + 2px);
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
  border-radius: 0.25rem;
}
.form-control-sm::-webkit-file-upload-button {
  padding: 0.25rem 0.5rem;
  margin: -0.25rem -0.5rem;
  -webkit-margin-end: 0.5rem;
  margin-inline-end: 0.5rem;
}
.form-control-sm::file-selector-button {
  padding: 0.25rem 0.5rem;
  margin: -0.25rem -0.5rem;
  -webkit-margin-end: 0.5rem;
  margin-inline-end: 0.5rem;
}

.form-control-lg {
  min-height: calc(1.5em + 1rem + 2px);
  padding: 0.5rem 1rem;
  font-size: 1.25rem;
  border-radius: 0.5rem;
}
.form-control-lg::-webkit-file-upload-button {
  padding: 0.5rem 1rem;
  margin: -0.5rem -1rem;
  -webkit-margin-end: 1rem;
  margin-inline-end: 1rem;
}
.form-control-lg::file-selector-button {
  padding: 0.5rem 1rem;
  margin: -0.5rem -1rem;
  -webkit-margin-end: 1rem;
  margin-inline-end: 1rem;
}

textarea.form-control {
  min-height: calc(1.5em + 0.75rem + 2px);
}
textarea.form-control-sm {
  min-height: calc(1.5em + 0.5rem + 2px);
}
textarea.form-control-lg {
  min-height: calc(1.5em + 1rem + 2px);
}

.form-control-color {
  width: 3rem;
  height: calc(1.5em + 0.75rem + 2px);
  padding: 0.375rem;
}
.form-control-color:not(:disabled):not([readonly]) {
  cursor: pointer;
}
.form-control-color::-moz-color-swatch {
  border: 0 !important;
  border-radius: 0.375rem;
}
.form-control-color::-webkit-color-swatch {
  border-radius: 0.375rem;
}
.form-control-color.form-control-sm {
  height: calc(1.5em + 0.5rem + 2px);
}
.form-control-color.form-control-lg {
  height: calc(1.5em + 1rem + 2px);
}

.form-select {
  display: block;
  width: 100%;
  padding: 0.375rem 2.25rem 0.375rem 0.75rem;
  -moz-padding-start: calc(0.75rem - 3px);
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
  color: #212529;
  background-color: #fff;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 16px 12px;
  border: 1px solid #ced4da;
  border-radius: 0.375rem;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}
@media (prefers-reduced-motion: reduce) {
  .form-select {
    transition: none;
  }
}
.form-select:focus {
  border-color: #86b7fe;
  outline: 0;
  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}
.form-select[multiple], .form-select[size]:not([size="1"]) {
  padding-right: 0.75rem;
  background-image: none;
}
.form-select:disabled {
  background-color: #e9ecef;
}
.form-select:-moz-focusring {
  color: transparent;
  text-shadow: 0 0 0 #212529;
}

.form-select-sm {
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  padding-left: 0.5rem;
  font-size: 0.875rem;
  border-radius: 0.25rem;
}

.form-select-lg {
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
  padding-left: 1rem;
  font-size: 1.25rem;
  border-radius: 0.5rem;
}

.form-check {
  display: block;
  min-height: 1.5rem;
  padding-left: 1.5em;
  margin-bottom: 0.125rem;
}
.form-check .form-check-input {
  float: left;
  margin-left: -1.5em;
}

.form-check-reverse {
  padding-right: 1.5em;
  padding-left: 0;
  text-align: right;
}
.form-check-reverse .form-check-input {
  float: right;
  margin-right: -1.5em;
  margin-left: 0;
}

.form-check-input {
  width: 1em;
  height: 1em;
  margin-top: 0.25em;
  vertical-align: top;
  background-color: #fff;
  background-repeat: no-repeat;
  background-position: center;
  background-size: contain;
  border: 1px solid rgba(0, 0, 0, 0.25);
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  -webkit-print-color-adjust: exact;
  color-adjust: exact;
  print-color-adjust: exact;
}
.form-check-input[type=checkbox] {
  border-radius: 0.25em;
}
.form-check-input[type=radio] {
  border-radius: 50%;
}
.form-check-input:active {
  filter: brightness(90%);
}
.form-check-input:focus {
  border-color: #86b7fe;
  outline: 0;
  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}
.form-check-input:checked {
  background-color: #0d6efd;
  border-color: #0d6efd;
}
.form-check-input:checked[type=checkbox] {
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='m6 10 3 3 6-6'/%3e%3c/svg%3e");
}
.form-check-input:checked[type=radio] {
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='-4 -4 8 8'%3e%3ccircle r='2' fill='%23fff'/%3e%3c/svg%3e");
}
.form-check-input[type=checkbox]:indeterminate {
  background-color: #0d6efd;
  border-color: #0d6efd;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='M6 10h8'/%3e%3c/svg%3e");
}
.form-check-input:disabled {
  pointer-events: none;
  filter: none;
  opacity: 0.5;
}
.form-check-input[disabled] ~ .form-check-label, .form-check-input:disabled ~ .form-check-label {
  cursor: default;
  opacity: 0.5;
}

.form-switch {
  padding-left: 2.5em;
}
.form-switch .form-check-input {
  width: 2em;
  margin-left: -2.5em;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='-4 -4 8 8'%3e%3ccircle r='3' fill='rgba%280, 0, 0, 0.25%29'/%3e%3c/svg%3e");
  background-position: left center;
  border-radius: 2em;
  transition: background-position 0.15s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .form-switch .form-check-input {
    transition: none;
  }
}
.form-switch .form-check-input:focus {
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='-4 -4 8 8'%3e%3ccircle r='3' fill='%2386b7fe'/%3e%3c/svg%3e");
}
.form-switch .form-check-input:checked {
  background-position: right center;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='-4 -4 8 8'%3e%3ccircle r='3' fill='%23fff'/%3e%3c/svg%3e");
}
.form-switch.form-check-reverse {
  padding-right: 2.5em;
  padding-left: 0;
}
.form-switch.form-check-reverse .form-check-input {
  margin-right: -2.5em;
  margin-left: 0;
}

.form-check-inline {
  display: inline-block;
  margin-right: 1rem;
}

.btn-check {
  position: absolute;
  clip: rect(0, 0, 0, 0);
  pointer-events: none;
}
.btn-check[disabled] + .btn, .btn-check:disabled + .btn {
  pointer-events: none;
  filter: none;
  opacity: 0.65;
}

.form-range {
  width: 100%;
  height: 1.5rem;
  padding: 0;
  background-color: transparent;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}
.form-range:focus {
  outline: 0;
}
.form-range:focus::-webkit-slider-thumb {
  box-shadow: 0 0 0 1px #fff, 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}
.form-range:focus::-moz-range-thumb {
  box-shadow: 0 0 0 1px #fff, 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}
.form-range::-moz-focus-outer {
  border: 0;
}
.form-range::-webkit-slider-thumb {
  width: 1rem;
  height: 1rem;
  margin-top: -0.25rem;
  background-color: #0d6efd;
  border: 0;
  border-radius: 1rem;
  -webkit-transition: background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  transition: background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  -webkit-appearance: none;
  appearance: none;
}
@media (prefers-reduced-motion: reduce) {
  .form-range::-webkit-slider-thumb {
    -webkit-transition: none;
    transition: none;
  }
}
.form-range::-webkit-slider-thumb:active {
  background-color: #b6d4fe;
}
.form-range::-webkit-slider-runnable-track {
  width: 100%;
  height: 0.5rem;
  color: transparent;
  cursor: pointer;
  background-color: #dee2e6;
  border-color: transparent;
  border-radius: 1rem;
}
.form-range::-moz-range-thumb {
  width: 1rem;
  height: 1rem;
  background-color: #0d6efd;
  border: 0;
  border-radius: 1rem;
  -moz-transition: background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  transition: background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  -moz-appearance: none;
  appearance: none;
}
@media (prefers-reduced-motion: reduce) {
  .form-range::-moz-range-thumb {
    -moz-transition: none;
    transition: none;
  }
}
.form-range::-moz-range-thumb:active {
  background-color: #b6d4fe;
}
.form-range::-moz-range-track {
  width: 100%;
  height: 0.5rem;
  color: transparent;
  cursor: pointer;
  background-color: #dee2e6;
  border-color: transparent;
  border-radius: 1rem;
}
.form-range:disabled {
  pointer-events: none;
}
.form-range:disabled::-webkit-slider-thumb {
  background-color: #adb5bd;
}
.form-range:disabled::-moz-range-thumb {
  background-color: #adb5bd;
}

.form-floating {
  position: relative;
}
.form-floating > .form-control,
.form-floating > .form-control-plaintext,
.form-floating > .form-select {
  height: calc(3.5rem + 2px);
  line-height: 1.25;
}
.form-floating > label {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 1rem 0.75rem;
  overflow: hidden;
  text-align: start;
  text-overflow: ellipsis;
  white-space: nowrap;
  pointer-events: none;
  border: 1px solid transparent;
  transform-origin: 0 0;
  transition: opacity 0.1s ease-in-out, transform 0.1s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .form-floating > label {
    transition: none;
  }
}
.form-floating > .form-control,
.form-floating > .form-control-plaintext {
  padding: 1rem 0.75rem;
}
.form-floating > .form-control::-moz-placeholder, .form-floating > .form-control-plaintext::-moz-placeholder {
  color: transparent;
}
.form-floating > .form-control::placeholder,
.form-floating > .form-control-plaintext::placeholder {
  color: transparent;
}
.form-floating > .form-control:not(:-moz-placeholder-shown), .form-floating > .form-control-plaintext:not(:-moz-placeholder-shown) {
  padding-top: 1.625rem;
  padding-bottom: 0.625rem;
}
.form-floating > .form-control:focus, .form-floating > .form-control:not(:placeholder-shown),
.form-floating > .form-control-plaintext:focus,
.form-floating > .form-control-plaintext:not(:placeholder-shown) {
  padding-top: 1.625rem;
  padding-bottom: 0.625rem;
}
.form-floating > .form-control:-webkit-autofill,
.form-floating > .form-control-plaintext:-webkit-autofill {
  padding-top: 1.625rem;
  padding-bottom: 0.625rem;
}
.form-floating > .form-select {
  padding-top: 1.625rem;
  padding-bottom: 0.625rem;
}
.form-floating > .form-control:not(:-moz-placeholder-shown) ~ label {
  opacity: 0.65;
  transform: scale(0.85) translateY(-0.5rem) translateX(0.15rem);
}
.form-floating > .form-control:focus ~ label,
.form-floating > .form-control:not(:placeholder-shown) ~ label,
.form-floating > .form-control-plaintext ~ label,
.form-floating > .form-select ~ label {
  opacity: 0.65;
  transform: scale(0.85) translateY(-0.5rem) translateX(0.15rem);
}
.form-floating > .form-control:-webkit-autofill ~ label {
  opacity: 0.65;
  transform: scale(0.85) translateY(-0.5rem) translateX(0.15rem);
}
.form-floating > .form-control-plaintext ~ label {
  border-width: 1px 0;
}

.input-group {
  position: relative;
  display: flex;
  flex-wrap: wrap;
  align-items: stretch;
  width: 100%;
}
.input-group > .form-control,
.input-group > .form-select,
.input-group > .form-floating {
  position: relative;
  flex: 1 1 auto;
  width: 1%;
  min-width: 0;
}
.input-group > .form-control:focus,
.input-group > .form-select:focus,
.input-group > .form-floating:focus-within {
  z-index: 5;
}
.input-group .btn {
  position: relative;
  z-index: 2;
}
.input-group .btn:focus {
  z-index: 5;
}

.input-group-text {
  display: flex;
  align-items: center;
  padding: 0.375rem 0.75rem;
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
  color: #212529;
  text-align: center;
  white-space: nowrap;
  background-color: #e9ecef;
  border: 1px solid #ced4da;
  border-radius: 0.375rem;
}

.input-group-lg > .form-control,
.input-group-lg > .form-select,
.input-group-lg > .input-group-text,
.input-group-lg > .btn {
  padding: 0.5rem 1rem;
  font-size: 1.25rem;
  border-radius: 0.5rem;
}

.input-group-sm > .form-control,
.input-group-sm > .form-select,
.input-group-sm > .input-group-text,
.input-group-sm > .btn {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
  border-radius: 0.25rem;
}

.input-group-lg > .form-select,
.input-group-sm > .form-select {
  padding-right: 3rem;
}

.input-group:not(.has-validation) > :not(:last-child):not(.dropdown-toggle):not(.dropdown-menu):not(.form-floating),
.input-group:not(.has-validation) > .dropdown-toggle:nth-last-child(n+3),
.input-group:not(.has-validation) > .form-floating:not(:last-child) > .form-control,
.input-group:not(.has-validation) > .form-floating:not(:last-child) > .form-select {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
}
.input-group.has-validation > :nth-last-child(n+3):not(.dropdown-toggle):not(.dropdown-menu):not(.form-floating),
.input-group.has-validation > .dropdown-toggle:nth-last-child(n+4),
.input-group.has-validation > .form-floating:nth-last-child(n+3) > .form-control,
.input-group.has-validation > .form-floating:nth-last-child(n+3) > .form-select {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
}
.input-group > :not(:first-child):not(.dropdown-menu):not(.valid-tooltip):not(.valid-feedback):not(.invalid-tooltip):not(.invalid-feedback) {
  margin-left: -1px;
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
}
.input-group > .form-floating:not(:first-child) > .form-control,
.input-group > .form-floating:not(:first-child) > .form-select {
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
}

.valid-feedback {
  display: none;
  width: 100%;
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #198754;
}

.valid-tooltip {
  position: absolute;
  top: 100%;
  z-index: 5;
  display: none;
  max-width: 100%;
  padding: 0.25rem 0.5rem;
  margin-top: 0.1rem;
  font-size: 0.875rem;
  color: #fff;
  background-color: rgba(25, 135, 84, 0.9);
  border-radius: 0.375rem;
}

.was-validated :valid ~ .valid-feedback,
.was-validated :valid ~ .valid-tooltip,
.is-valid ~ .valid-feedback,
.is-valid ~ .valid-tooltip {
  display: block;
}

.was-validated .form-control:valid, .form-control.is-valid {
  border-color: #198754;
  padding-right: calc(1.5em + 0.75rem);
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right calc(0.375em + 0.1875rem) center;
  background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
}
.was-validated .form-control:valid:focus, .form-control.is-valid:focus {
  border-color: #198754;
  box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25);
}

.was-validated textarea.form-control:valid, textarea.form-control.is-valid {
  padding-right: calc(1.5em + 0.75rem);
  background-position: top calc(0.375em + 0.1875rem) right calc(0.375em + 0.1875rem);
}

.was-validated .form-select:valid, .form-select.is-valid {
  border-color: #198754;
}
.was-validated .form-select:valid:not([multiple]):not([size]), .was-validated .form-select:valid:not([multiple])[size="1"], .form-select.is-valid:not([multiple]):not([size]), .form-select.is-valid:not([multiple])[size="1"] {
  padding-right: 4.125rem;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e"), url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
  background-position: right 0.75rem center, center right 2.25rem;
  background-size: 16px 12px, calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
}
.was-validated .form-select:valid:focus, .form-select.is-valid:focus {
  border-color: #198754;
  box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25);
}

.was-validated .form-control-color:valid, .form-control-color.is-valid {
  width: calc(3rem + calc(1.5em + 0.75rem));
}

.was-validated .form-check-input:valid, .form-check-input.is-valid {
  border-color: #198754;
}
.was-validated .form-check-input:valid:checked, .form-check-input.is-valid:checked {
  background-color: #198754;
}
.was-validated .form-check-input:valid:focus, .form-check-input.is-valid:focus {
  box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25);
}
.was-validated .form-check-input:valid ~ .form-check-label, .form-check-input.is-valid ~ .form-check-label {
  color: #198754;
}

.form-check-inline .form-check-input ~ .valid-feedback {
  margin-left: 0.5em;
}

.was-validated .input-group > .form-control:not(:focus):valid, .input-group > .form-control:not(:focus).is-valid,
.was-validated .input-group > .form-select:not(:focus):valid,
.input-group > .form-select:not(:focus).is-valid,
.was-validated .input-group > .form-floating:not(:focus-within):valid,
.input-group > .form-floating:not(:focus-within).is-valid {
  z-index: 3;
}

.invalid-feedback {
  display: none;
  width: 100%;
  margin-top: 0.25rem;
  font-size: 0.875em;
  color: #dc3545;
}

.invalid-tooltip {
  position: absolute;
  top: 100%;
  z-index: 5;
  display: none;
  max-width: 100%;
  padding: 0.25rem 0.5rem;
  margin-top: 0.1rem;
  font-size: 0.875rem;
  color: #fff;
  background-color: rgba(220, 53, 69, 0.9);
  border-radius: 0.375rem;
}

.was-validated :invalid ~ .invalid-feedback,
.was-validated :invalid ~ .invalid-tooltip,
.is-invalid ~ .invalid-feedback,
.is-invalid ~ .invalid-tooltip {
  display: block;
}

.was-validated .form-control:invalid, .form-control.is-invalid {
  border-color: #dc3545;
  padding-right: calc(1.5em + 0.75rem);
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right calc(0.375em + 0.1875rem) center;
  background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
}
.was-validated .form-control:invalid:focus, .form-control.is-invalid:focus {
  border-color: #dc3545;
  box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
}

.was-validated textarea.form-control:invalid, textarea.form-control.is-invalid {
  padding-right: calc(1.5em + 0.75rem);
  background-position: top calc(0.375em + 0.1875rem) right calc(0.375em + 0.1875rem);
}

.was-validated .form-select:invalid, .form-select.is-invalid {
  border-color: #dc3545;
}
.was-validated .form-select:invalid:not([multiple]):not([size]), .was-validated .form-select:invalid:not([multiple])[size="1"], .form-select.is-invalid:not([multiple]):not([size]), .form-select.is-invalid:not([multiple])[size="1"] {
  padding-right: 4.125rem;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e"), url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
  background-position: right 0.75rem center, center right 2.25rem;
  background-size: 16px 12px, calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
}
.was-validated .form-select:invalid:focus, .form-select.is-invalid:focus {
  border-color: #dc3545;
  box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
}

.was-validated .form-control-color:invalid, .form-control-color.is-invalid {
  width: calc(3rem + calc(1.5em + 0.75rem));
}

.was-validated .form-check-input:invalid, .form-check-input.is-invalid {
  border-color: #dc3545;
}
.was-validated .form-check-input:invalid:checked, .form-check-input.is-invalid:checked {
  background-color: #dc3545;
}
.was-validated .form-check-input:invalid:focus, .form-check-input.is-invalid:focus {
  box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
}
.was-validated .form-check-input:invalid ~ .form-check-label, .form-check-input.is-invalid ~ .form-check-label {
  color: #dc3545;
}

.form-check-inline .form-check-input ~ .invalid-feedback {
  margin-left: 0.5em;
}

.was-validated .input-group > .form-control:not(:focus):invalid, .input-group > .form-control:not(:focus).is-invalid,
.was-validated .input-group > .form-select:not(:focus):invalid,
.input-group > .form-select:not(:focus).is-invalid,
.was-validated .input-group > .form-floating:not(:focus-within):invalid,
.input-group > .form-floating:not(:focus-within).is-invalid {
  z-index: 4;
}

.btn {
  --bs-btn-padding-x: 0.75rem;
  --bs-btn-padding-y: 0.375rem;
  --bs-btn-font-family: ;
  --bs-btn-font-size: 1rem;
  --bs-btn-font-weight: 400;
  --bs-btn-line-height: 1.5;
  --bs-btn-color: #212529;
  --bs-btn-bg: transparent;
  --bs-btn-border-width: 1px;
  --bs-btn-border-color: transparent;
  --bs-btn-border-radius: 0.375rem;
  --bs-btn-hover-border-color: transparent;
  --bs-btn-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.15), 0 1px 1px rgba(0, 0, 0, 0.075);
  --bs-btn-disabled-opacity: 0.65;
  --bs-btn-focus-box-shadow: 0 0 0 0.25rem rgba(var(--bs-btn-focus-shadow-rgb), .5);
  display: inline-block;
  padding: var(--bs-btn-padding-y) var(--bs-btn-padding-x);
  font-family: var(--bs-btn-font-family);
  font-size: var(--bs-btn-font-size);
  font-weight: var(--bs-btn-font-weight);
  line-height: var(--bs-btn-line-height);
  color: var(--bs-btn-color);
  text-align: center;
  text-decoration: none;
  vertical-align: middle;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  user-select: none;
  border: var(--bs-btn-border-width) solid var(--bs-btn-border-color);
  border-radius: var(--bs-btn-border-radius);
  background-color: var(--bs-btn-bg);
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .btn {
    transition: none;
  }
}
.btn:hover {
  color: var(--bs-btn-hover-color);
  background-color: var(--bs-btn-hover-bg);
  border-color: var(--bs-btn-hover-border-color);
}
.btn-check + .btn:hover {
  color: var(--bs-btn-color);
  background-color: var(--bs-btn-bg);
  border-color: var(--bs-btn-border-color);
}
.btn:focus-visible {
  color: var(--bs-btn-hover-color);
  background-color: var(--bs-btn-hover-bg);
  border-color: var(--bs-btn-hover-border-color);
  outline: 0;
  box-shadow: var(--bs-btn-focus-box-shadow);
}
.btn-check:focus-visible + .btn {
  border-color: var(--bs-btn-hover-border-color);
  outline: 0;
  box-shadow: var(--bs-btn-focus-box-shadow);
}
.btn-check:checked + .btn, :not(.btn-check) + .btn:active, .btn:first-child:active, .btn.active, .btn.show {
  color: var(--bs-btn-active-color);
  background-color: var(--bs-btn-active-bg);
  border-color: var(--bs-btn-active-border-color);
}
.btn-check:checked + .btn:focus-visible, :not(.btn-check) + .btn:active:focus-visible, .btn:first-child:active:focus-visible, .btn.active:focus-visible, .btn.show:focus-visible {
  box-shadow: var(--bs-btn-focus-box-shadow);
}
.btn:disabled, .btn.disabled, fieldset:disabled .btn {
  color: var(--bs-btn-disabled-color);
  pointer-events: none;
  background-color: var(--bs-btn-disabled-bg);
  border-color: var(--bs-btn-disabled-border-color);
  opacity: var(--bs-btn-disabled-opacity);
}

.btn-primary {
  --bs-btn-color: #fff;
  --bs-btn-bg: #0d6efd;
  --bs-btn-border-color: #0d6efd;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #0b5ed7;
  --bs-btn-hover-border-color: #0a58ca;
  --bs-btn-focus-shadow-rgb: 49, 132, 253;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #0a58ca;
  --bs-btn-active-border-color: #0a53be;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #fff;
  --bs-btn-disabled-bg: #0d6efd;
  --bs-btn-disabled-border-color: #0d6efd;
}

.btn-secondary {
  --bs-btn-color: #fff;
  --bs-btn-bg: #6c757d;
  --bs-btn-border-color: #6c757d;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #5c636a;
  --bs-btn-hover-border-color: #565e64;
  --bs-btn-focus-shadow-rgb: 130, 138, 145;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #565e64;
  --bs-btn-active-border-color: #51585e;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #fff;
  --bs-btn-disabled-bg: #6c757d;
  --bs-btn-disabled-border-color: #6c757d;
}

.btn-success {
  --bs-btn-color: #fff;
  --bs-btn-bg: #198754;
  --bs-btn-border-color: #198754;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #157347;
  --bs-btn-hover-border-color: #146c43;
  --bs-btn-focus-shadow-rgb: 60, 153, 110;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #146c43;
  --bs-btn-active-border-color: #13653f;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #fff;
  --bs-btn-disabled-bg: #198754;
  --bs-btn-disabled-border-color: #198754;
}

.btn-info {
  --bs-btn-color: #000;
  --bs-btn-bg: #0dcaf0;
  --bs-btn-border-color: #0dcaf0;
  --bs-btn-hover-color: #000;
  --bs-btn-hover-bg: #31d2f2;
  --bs-btn-hover-border-color: #25cff2;
  --bs-btn-focus-shadow-rgb: 11, 172, 204;
  --bs-btn-active-color: #000;
  --bs-btn-active-bg: #3dd5f3;
  --bs-btn-active-border-color: #25cff2;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #000;
  --bs-btn-disabled-bg: #0dcaf0;
  --bs-btn-disabled-border-color: #0dcaf0;
}

.btn-warning {
  --bs-btn-color: #000;
  --bs-btn-bg: #ffc107;
  --bs-btn-border-color: #ffc107;
  --bs-btn-hover-color: #000;
  --bs-btn-hover-bg: #ffca2c;
  --bs-btn-hover-border-color: #ffc720;
  --bs-btn-focus-shadow-rgb: 217, 164, 6;
  --bs-btn-active-color: #000;
  --bs-btn-active-bg: #ffcd39;
  --bs-btn-active-border-color: #ffc720;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #000;
  --bs-btn-disabled-bg: #ffc107;
  --bs-btn-disabled-border-color: #ffc107;
}

.btn-danger {
  --bs-btn-color: #fff;
  --bs-btn-bg: #dc3545;
  --bs-btn-border-color: #dc3545;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #bb2d3b;
  --bs-btn-hover-border-color: #b02a37;
  --bs-btn-focus-shadow-rgb: 225, 83, 97;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #b02a37;
  --bs-btn-active-border-color: #a52834;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #fff;
  --bs-btn-disabled-bg: #dc3545;
  --bs-btn-disabled-border-color: #dc3545;
}

.btn-light {
  --bs-btn-color: #000;
  --bs-btn-bg: #f8f9fa;
  --bs-btn-border-color: #f8f9fa;
  --bs-btn-hover-color: #000;
  --bs-btn-hover-bg: #d3d4d5;
  --bs-btn-hover-border-color: #c6c7c8;
  --bs-btn-focus-shadow-rgb: 211, 212, 213;
  --bs-btn-active-color: #000;
  --bs-btn-active-bg: #c6c7c8;
  --bs-btn-active-border-color: #babbbc;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #000;
  --bs-btn-disabled-bg: #f8f9fa;
  --bs-btn-disabled-border-color: #f8f9fa;
}

.btn-dark {
  --bs-btn-color: #fff;
  --bs-btn-bg: #212529;
  --bs-btn-border-color: #212529;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #424649;
  --bs-btn-hover-border-color: #373b3e;
  --bs-btn-focus-shadow-rgb: 66, 70, 73;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #4d5154;
  --bs-btn-active-border-color: #373b3e;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #fff;
  --bs-btn-disabled-bg: #212529;
  --bs-btn-disabled-border-color: #212529;
}

.btn-outline-primary {
  --bs-btn-color: #0d6efd;
  --bs-btn-border-color: #0d6efd;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #0d6efd;
  --bs-btn-hover-border-color: #0d6efd;
  --bs-btn-focus-shadow-rgb: 13, 110, 253;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #0d6efd;
  --bs-btn-active-border-color: #0d6efd;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #0d6efd;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #0d6efd;
  --bs-gradient: none;
}

.btn-outline-secondary {
  --bs-btn-color: #6c757d;
  --bs-btn-border-color: #6c757d;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #6c757d;
  --bs-btn-hover-border-color: #6c757d;
  --bs-btn-focus-shadow-rgb: 108, 117, 125;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #6c757d;
  --bs-btn-active-border-color: #6c757d;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #6c757d;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #6c757d;
  --bs-gradient: none;
}

.btn-outline-success {
  --bs-btn-color: #198754;
  --bs-btn-border-color: #198754;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #198754;
  --bs-btn-hover-border-color: #198754;
  --bs-btn-focus-shadow-rgb: 25, 135, 84;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #198754;
  --bs-btn-active-border-color: #198754;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #198754;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #198754;
  --bs-gradient: none;
}

.btn-outline-info {
  --bs-btn-color: #0dcaf0;
  --bs-btn-border-color: #0dcaf0;
  --bs-btn-hover-color: #000;
  --bs-btn-hover-bg: #0dcaf0;
  --bs-btn-hover-border-color: #0dcaf0;
  --bs-btn-focus-shadow-rgb: 13, 202, 240;
  --bs-btn-active-color: #000;
  --bs-btn-active-bg: #0dcaf0;
  --bs-btn-active-border-color: #0dcaf0;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #0dcaf0;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #0dcaf0;
  --bs-gradient: none;
}

.btn-outline-warning {
  --bs-btn-color: #ffc107;
  --bs-btn-border-color: #ffc107;
  --bs-btn-hover-color: #000;
  --bs-btn-hover-bg: #ffc107;
  --bs-btn-hover-border-color: #ffc107;
  --bs-btn-focus-shadow-rgb: 255, 193, 7;
  --bs-btn-active-color: #000;
  --bs-btn-active-bg: #ffc107;
  --bs-btn-active-border-color: #ffc107;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #ffc107;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #ffc107;
  --bs-gradient: none;
}

.btn-outline-danger {
  --bs-btn-color: #dc3545;
  --bs-btn-border-color: #dc3545;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #dc3545;
  --bs-btn-hover-border-color: #dc3545;
  --bs-btn-focus-shadow-rgb: 220, 53, 69;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #dc3545;
  --bs-btn-active-border-color: #dc3545;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #dc3545;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #dc3545;
  --bs-gradient: none;
}

.btn-outline-light {
  --bs-btn-color: #f8f9fa;
  --bs-btn-border-color: #f8f9fa;
  --bs-btn-hover-color: #000;
  --bs-btn-hover-bg: #f8f9fa;
  --bs-btn-hover-border-color: #f8f9fa;
  --bs-btn-focus-shadow-rgb: 248, 249, 250;
  --bs-btn-active-color: #000;
  --bs-btn-active-bg: #f8f9fa;
  --bs-btn-active-border-color: #f8f9fa;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #f8f9fa;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #f8f9fa;
  --bs-gradient: none;
}

.btn-outline-dark {
  --bs-btn-color: #212529;
  --bs-btn-border-color: #212529;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg: #212529;
  --bs-btn-hover-border-color: #212529;
  --bs-btn-focus-shadow-rgb: 33, 37, 41;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg: #212529;
  --bs-btn-active-border-color: #212529;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color: #212529;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color: #212529;
  --bs-gradient: none;
}

.btn-link {
  --bs-btn-font-weight: 400;
  --bs-btn-color: var(--bs-link-color);
  --bs-btn-bg: transparent;
  --bs-btn-border-color: transparent;
  --bs-btn-hover-color: var(--bs-link-hover-color);
  --bs-btn-hover-border-color: transparent;
  --bs-btn-active-color: var(--bs-link-hover-color);
  --bs-btn-active-border-color: transparent;
  --bs-btn-disabled-color: #6c757d;
  --bs-btn-disabled-border-color: transparent;
  --bs-btn-box-shadow: none;
  --bs-btn-focus-shadow-rgb: 49, 132, 253;
  text-decoration: underline;
}
.btn-link:focus-visible {
  color: var(--bs-btn-color);
}
.btn-link:hover {
  color: var(--bs-btn-hover-color);
}

.btn-lg, .btn-group-lg > .btn {
  --bs-btn-padding-y: 0.5rem;
  --bs-btn-padding-x: 1rem;
  --bs-btn-font-size: 1.25rem;
  --bs-btn-border-radius: 0.5rem;
}

.btn-sm, .btn-group-sm > .btn {
  --bs-btn-padding-y: 0.25rem;
  --bs-btn-padding-x: 0.5rem;
  --bs-btn-font-size: 0.875rem;
  --bs-btn-border-radius: 0.25rem;
}

.fade {
  transition: opacity 0.15s linear;
}
@media (prefers-reduced-motion: reduce) {
  .fade {
    transition: none;
  }
}
.fade:not(.show) {
  opacity: 0;
}

.collapse:not(.show) {
  display: none;
}

.collapsing {
  height: 0;
  overflow: hidden;
  transition: height 0.35s ease;
}
@media (prefers-reduced-motion: reduce) {
  .collapsing {
    transition: none;
  }
}
.collapsing.collapse-horizontal {
  width: 0;
  height: auto;
  transition: width 0.35s ease;
}
@media (prefers-reduced-motion: reduce) {
  .collapsing.collapse-horizontal {
    transition: none;
  }
}

.dropup,
.dropend,
.dropdown,
.dropstart,
.dropup-center,
.dropdown-center {
  position: relative;
}

.dropdown-toggle {
  white-space: nowrap;
}
.dropdown-toggle::after {
  display: inline-block;
  margin-left: 0.255em;
  vertical-align: 0.255em;
  content: "";
  border-top: 0.3em solid;
  border-right: 0.3em solid transparent;
  border-bottom: 0;
  border-left: 0.3em solid transparent;
}
.dropdown-toggle:empty::after {
  margin-left: 0;
}

.dropdown-menu {
  --bs-dropdown-zindex: 1000;
  --bs-dropdown-min-width: 10rem;
  --bs-dropdown-padding-x: 0;
  --bs-dropdown-padding-y: 0.5rem;
  --bs-dropdown-spacer: 0.125rem;
  --bs-dropdown-font-size: 1rem;
  --bs-dropdown-color: #212529;
  --bs-dropdown-bg: #fff;
  --bs-dropdown-border-color: var(--bs-border-color-translucent);
  --bs-dropdown-border-radius: 0.375rem;
  --bs-dropdown-border-width: 1px;
  --bs-dropdown-inner-border-radius: calc(0.375rem - 1px);
  --bs-dropdown-divider-bg: var(--bs-border-color-translucent);
  --bs-dropdown-divider-margin-y: 0.5rem;
  --bs-dropdown-box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  --bs-dropdown-link-color: #212529;
  --bs-dropdown-link-hover-color: #1e2125;
  --bs-dropdown-link-hover-bg: #e9ecef;
  --bs-dropdown-link-active-color: #fff;
  --bs-dropdown-link-active-bg: #0d6efd;
  --bs-dropdown-link-disabled-color: #adb5bd;
  --bs-dropdown-item-padding-x: 1rem;
  --bs-dropdown-item-padding-y: 0.25rem;
  --bs-dropdown-header-color: #6c757d;
  --bs-dropdown-header-padding-x: 1rem;
  --bs-dropdown-header-padding-y: 0.5rem;
  position: absolute;
  z-index: var(--bs-dropdown-zindex);
  display: none;
  min-width: var(--bs-dropdown-min-width);
  padding: var(--bs-dropdown-padding-y) var(--bs-dropdown-padding-x);
  margin: 0;
  font-size: var(--bs-dropdown-font-size);
  color: var(--bs-dropdown-color);
  text-align: left;
  list-style: none;
  background-color: var(--bs-dropdown-bg);
  background-clip: padding-box;
  border: var(--bs-dropdown-border-width) solid var(--bs-dropdown-border-color);
  border-radius: var(--bs-dropdown-border-radius);
}
.dropdown-menu[data-bs-popper] {
  top: 100%;
  left: 0;
  margin-top: var(--bs-dropdown-spacer);
}

.dropdown-menu-start {
  --bs-position: start;
}
.dropdown-menu-start[data-bs-popper] {
  right: auto;
  left: 0;
}

.dropdown-menu-end {
  --bs-position: end;
}
.dropdown-menu-end[data-bs-popper] {
  right: 0;
  left: auto;
}

@media (min-width: 576px) {
  .dropdown-menu-sm-start {
    --bs-position: start;
  }
  .dropdown-menu-sm-start[data-bs-popper] {
    right: auto;
    left: 0;
  }
  .dropdown-menu-sm-end {
    --bs-position: end;
  }
  .dropdown-menu-sm-end[data-bs-popper] {
    right: 0;
    left: auto;
  }
}
@media (min-width: 768px) {
  .dropdown-menu-md-start {
    --bs-position: start;
  }
  .dropdown-menu-md-start[data-bs-popper] {
    right: auto;
    left: 0;
  }
  .dropdown-menu-md-end {
    --bs-position: end;
  }
  .dropdown-menu-md-end[data-bs-popper] {
    right: 0;
    left: auto;
  }
}
@media (min-width: 992px) {
  .dropdown-menu-lg-start {
    --bs-position: start;
  }
  .dropdown-menu-lg-start[data-bs-popper] {
    right: auto;
    left: 0;
  }
  .dropdown-menu-lg-end {
    --bs-position: end;
  }
  .dropdown-menu-lg-end[data-bs-popper] {
    right: 0;
    left: auto;
  }
}
@media (min-width: 1200px) {
  .dropdown-menu-xl-start {
    --bs-position: start;
  }
  .dropdown-menu-xl-start[data-bs-popper] {
    right: auto;
    left: 0;
  }
  .dropdown-menu-xl-end {
    --bs-position: end;
  }
  .dropdown-menu-xl-end[data-bs-popper] {
    right: 0;
    left: auto;
  }
}
@media (min-width: 1400px) {
  .dropdown-menu-xxl-start {
    --bs-position: start;
  }
  .dropdown-menu-xxl-start[data-bs-popper] {
    right: auto;
    left: 0;
  }
  .dropdown-menu-xxl-end {
    --bs-position: end;
  }
  .dropdown-menu-xxl-end[data-bs-popper] {
    right: 0;
    left: auto;
  }
}
.dropup .dropdown-menu[data-bs-popper] {
  top: auto;
  bottom: 100%;
  margin-top: 0;
  margin-bottom: var(--bs-dropdown-spacer);
}
.dropup .dropdown-toggle::after {
  display: inline-block;
  margin-left: 0.255em;
  vertical-align: 0.255em;
  content: "";
  border-top: 0;
  border-right: 0.3em solid transparent;
  border-bottom: 0.3em solid;
  border-left: 0.3em solid transparent;
}
.dropup .dropdown-toggle:empty::after {
  margin-left: 0;
}

.dropend .dropdown-menu[data-bs-popper] {
  top: 0;
  right: auto;
  left: 100%;
  margin-top: 0;
  margin-left: var(--bs-dropdown-spacer);
}
.dropend .dropdown-toggle::after {
  display: inline-block;
  margin-left: 0.255em;
  vertical-align: 0.255em;
  content: "";
  border-top: 0.3em solid transparent;
  border-right: 0;
  border-bottom: 0.3em solid transparent;
  border-left: 0.3em solid;
}
.dropend .dropdown-toggle:empty::after {
  margin-left: 0;
}
.dropend .dropdown-toggle::after {
  vertical-align: 0;
}

.dropstart .dropdown-menu[data-bs-popper] {
  top: 0;
  right: 100%;
  left: auto;
  margin-top: 0;
  margin-right: var(--bs-dropdown-spacer);
}
.dropstart .dropdown-toggle::after {
  display: inline-block;
  margin-left: 0.255em;
  vertical-align: 0.255em;
  content: "";
}
.dropstart .dropdown-toggle::after {
  display: none;
}
.dropstart .dropdown-toggle::before {
  display: inline-block;
  margin-right: 0.255em;
  vertical-align: 0.255em;
  content: "";
  border-top: 0.3em solid transparent;
  border-right: 0.3em solid;
  border-bottom: 0.3em solid transparent;
}
.dropstart .dropdown-toggle:empty::after {
  margin-left: 0;
}
.dropstart .dropdown-toggle::before {
  vertical-align: 0;
}

.dropdown-divider {
  height: 0;
  margin: var(--bs-dropdown-divider-margin-y) 0;
  overflow: hidden;
  border-top: 1px solid var(--bs-dropdown-divider-bg);
  opacity: 1;
}

.dropdown-item {
  display: block;
  width: 100%;
  padding: var(--bs-dropdown-item-padding-y) var(--bs-dropdown-item-padding-x);
  clear: both;
  font-weight: 400;
  color: var(--bs-dropdown-link-color);
  text-align: inherit;
  text-decoration: none;
  white-space: nowrap;
  background-color: transparent;
  border: 0;
}
.dropdown-item:hover, .dropdown-item:focus {
  color: var(--bs-dropdown-link-hover-color);
  background-color: var(--bs-dropdown-link-hover-bg);
}
.dropdown-item.active, .dropdown-item:active {
  color: var(--bs-dropdown-link-active-color);
  text-decoration: none;
  background-color: var(--bs-dropdown-link-active-bg);
}
.dropdown-item.disabled, .dropdown-item:disabled {
  color: var(--bs-dropdown-link-disabled-color);
  pointer-events: none;
  background-color: transparent;
}

.dropdown-menu.show {
  display: block;
}

.dropdown-header {
  display: block;
  padding: var(--bs-dropdown-header-padding-y) var(--bs-dropdown-header-padding-x);
  margin-bottom: 0;
  font-size: 0.875rem;
  color: var(--bs-dropdown-header-color);
  white-space: nowrap;
}

.dropdown-item-text {
  display: block;
  padding: var(--bs-dropdown-item-padding-y) var(--bs-dropdown-item-padding-x);
  color: var(--bs-dropdown-link-color);
}

.dropdown-menu-dark {
  --bs-dropdown-color: #dee2e6;
  --bs-dropdown-bg: #343a40;
  --bs-dropdown-border-color: var(--bs-border-color-translucent);
  --bs-dropdown-box-shadow: ;
  --bs-dropdown-link-color: #dee2e6;
  --bs-dropdown-link-hover-color: #fff;
  --bs-dropdown-divider-bg: var(--bs-border-color-translucent);
  --bs-dropdown-link-hover-bg: rgba(255, 255, 255, 0.15);
  --bs-dropdown-link-active-color: #fff;
  --bs-dropdown-link-active-bg: #0d6efd;
  --bs-dropdown-link-disabled-color: #adb5bd;
  --bs-dropdown-header-color: #adb5bd;
}

.btn-group,
.btn-group-vertical {
  position: relative;
  display: inline-flex;
  vertical-align: middle;
}
.btn-group > .btn,
.btn-group-vertical > .btn {
  position: relative;
  flex: 1 1 auto;
}
.btn-group > .btn-check:checked + .btn,
.btn-group > .btn-check:focus + .btn,
.btn-group > .btn:hover,
.btn-group > .btn:focus,
.btn-group > .btn:active,
.btn-group > .btn.active,
.btn-group-vertical > .btn-check:checked + .btn,
.btn-group-vertical > .btn-check:focus + .btn,
.btn-group-vertical > .btn:hover,
.btn-group-vertical > .btn:focus,
.btn-group-vertical > .btn:active,
.btn-group-vertical > .btn.active {
  z-index: 1;
}

.btn-toolbar {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-start;
}
.btn-toolbar .input-group {
  width: auto;
}

.btn-group {
  border-radius: 0.375rem;
}
.btn-group > :not(.btn-check:first-child) + .btn,
.btn-group > .btn-group:not(:first-child) {
  margin-left: -1px;
}
.btn-group > .btn:not(:last-child):not(.dropdown-toggle),
.btn-group > .btn.dropdown-toggle-split:first-child,
.btn-group > .btn-group:not(:last-child) > .btn {
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
}
.btn-group > .btn:nth-child(n+3),
.btn-group > :not(.btn-check) + .btn,
.btn-group > .btn-group:not(:first-child) > .btn {
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
}

.dropdown-toggle-split {
  padding-right: 0.5625rem;
  padding-left: 0.5625rem;
}
.dropdown-toggle-split::after, .dropup .dropdown-toggle-split::after, .dropend .dropdown-toggle-split::after {
  margin-left: 0;
}
.dropstart .dropdown-toggle-split::before {
  margin-right: 0;
}

.btn-sm + .dropdown-toggle-split, .btn-group-sm > .btn + .dropdown-toggle-split {
  padding-right: 0.375rem;
  padding-left: 0.375rem;
}

.btn-lg + .dropdown-toggle-split, .btn-group-lg > .btn + .dropdown-toggle-split {
  padding-right: 0.75rem;
  padding-left: 0.75rem;
}

.btn-group-vertical {
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
}
.btn-group-vertical > .btn,
.btn-group-vertical > .btn-group {
  width: 100%;
}
.btn-group-vertical > .btn:not(:first-child),
.btn-group-vertical > .btn-group:not(:first-child) {
  margin-top: -1px;
}
.btn-group-vertical > .btn:not(:last-child):not(.dropdown-toggle),
.btn-group-vertical > .btn-group:not(:last-child) > .btn {
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}
.btn-group-vertical > .btn ~ .btn,
.btn-group-vertical > .btn-group:not(:first-child) > .btn {
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}

.nav {
  --bs-nav-link-padding-x: 1rem;
  --bs-nav-link-padding-y: 0.5rem;
  --bs-nav-link-font-weight: ;
  --bs-nav-link-color: var(--bs-link-color);
  --bs-nav-link-hover-color: var(--bs-link-hover-color);
  --bs-nav-link-disabled-color: #6c757d;
  display: flex;
  flex-wrap: wrap;
  padding-left: 0;
  margin-bottom: 0;
  list-style: none;
}

.nav-link {
  display: block;
  padding: var(--bs-nav-link-padding-y) var(--bs-nav-link-padding-x);
  font-size: var(--bs-nav-link-font-size);
  font-weight: var(--bs-nav-link-font-weight);
  color: var(--bs-nav-link-color);
  text-decoration: none;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .nav-link {
    transition: none;
  }
}
.nav-link:hover, .nav-link:focus {
  color: var(--bs-nav-link-hover-color);
}
.nav-link.disabled {
  color: var(--bs-nav-link-disabled-color);
  pointer-events: none;
  cursor: default;
}

.nav-tabs {
  --bs-nav-tabs-border-width: 1px;
  --bs-nav-tabs-border-color: #dee2e6;
  --bs-nav-tabs-border-radius: 0.375rem;
  --bs-nav-tabs-link-hover-border-color: #e9ecef #e9ecef #dee2e6;
  --bs-nav-tabs-link-active-color: #495057;
  --bs-nav-tabs-link-active-bg: #fff;
  --bs-nav-tabs-link-active-border-color: #dee2e6 #dee2e6 #fff;
  border-bottom: var(--bs-nav-tabs-border-width) solid var(--bs-nav-tabs-border-color);
}
.nav-tabs .nav-link {
  margin-bottom: calc(-1 * var(--bs-nav-tabs-border-width));
  background: none;
  border: var(--bs-nav-tabs-border-width) solid transparent;
  border-top-left-radius: var(--bs-nav-tabs-border-radius);
  border-top-right-radius: var(--bs-nav-tabs-border-radius);
}
.nav-tabs .nav-link:hover, .nav-tabs .nav-link:focus {
  isolation: isolate;
  border-color: var(--bs-nav-tabs-link-hover-border-color);
}
.nav-tabs .nav-link.disabled, .nav-tabs .nav-link:disabled {
  color: var(--bs-nav-link-disabled-color);
  background-color: transparent;
  border-color: transparent;
}
.nav-tabs .nav-link.active,
.nav-tabs .nav-item.show .nav-link {
  color: var(--bs-nav-tabs-link-active-color);
  background-color: var(--bs-nav-tabs-link-active-bg);
  border-color: var(--bs-nav-tabs-link-active-border-color);
}
.nav-tabs .dropdown-menu {
  margin-top: calc(-1 * var(--bs-nav-tabs-border-width));
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}

.nav-pills {
  --bs-nav-pills-border-radius: 0.375rem;
  --bs-nav-pills-link-active-color: #fff;
  --bs-nav-pills-link-active-bg: #0d6efd;
}
.nav-pills .nav-link {
  background: none;
  border: 0;
  border-radius: var(--bs-nav-pills-border-radius);
}
.nav-pills .nav-link:disabled {
  color: var(--bs-nav-link-disabled-color);
  background-color: transparent;
  border-color: transparent;
}
.nav-pills .nav-link.active,
.nav-pills .show > .nav-link {
  color: var(--bs-nav-pills-link-active-color);
  background-color: var(--bs-nav-pills-link-active-bg);
}

.nav-fill > .nav-link,
.nav-fill .nav-item {
  flex: 1 1 auto;
  text-align: center;
}

.nav-justified > .nav-link,
.nav-justified .nav-item {
  flex-basis: 0;
  flex-grow: 1;
  text-align: center;
}

.nav-fill .nav-item .nav-link,
.nav-justified .nav-item .nav-link {
  width: 100%;
}

.tab-content > .tab-pane {
  display: none;
}
.tab-content > .active {
  display: block;
}

.navbar {
  --bs-navbar-padding-x: 0;
  --bs-navbar-padding-y: 0.5rem;
  --bs-navbar-color: rgba(0, 0, 0, 0.55);
  --bs-navbar-hover-color: rgba(0, 0, 0, 0.7);
  --bs-navbar-disabled-color: rgba(0, 0, 0, 0.3);
  --bs-navbar-active-color: rgba(0, 0, 0, 0.9);
  --bs-navbar-brand-padding-y: 0.3125rem;
  --bs-navbar-brand-margin-end: 1rem;
  --bs-navbar-brand-font-size: 1.25rem;
  --bs-navbar-brand-color: rgba(0, 0, 0, 0.9);
  --bs-navbar-brand-hover-color: rgba(0, 0, 0, 0.9);
  --bs-navbar-nav-link-padding-x: 0.5rem;
  --bs-navbar-toggler-padding-y: 0.25rem;
  --bs-navbar-toggler-padding-x: 0.75rem;
  --bs-navbar-toggler-font-size: 1.25rem;
  --bs-navbar-toggler-icon-bg: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%280, 0, 0, 0.55%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
  --bs-navbar-toggler-border-color: rgba(0, 0, 0, 0.1);
  --bs-navbar-toggler-border-radius: 0.375rem;
  --bs-navbar-toggler-focus-width: 0.25rem;
  --bs-navbar-toggler-transition: box-shadow 0.15s ease-in-out;
  position: relative;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  padding: var(--bs-navbar-padding-y) var(--bs-navbar-padding-x);
}
.navbar > .container,
.navbar > .container-fluid,
.navbar > .container-sm,
.navbar > .container-md,
.navbar > .container-lg,
.navbar > .container-xl,
.navbar > .container-xxl {
  display: flex;
  flex-wrap: inherit;
  align-items: center;
  justify-content: space-between;
}
.navbar-brand {
  padding-top: var(--bs-navbar-brand-padding-y);
  padding-bottom: var(--bs-navbar-brand-padding-y);
  margin-right: var(--bs-navbar-brand-margin-end);
  font-size: var(--bs-navbar-brand-font-size);
  color: var(--bs-navbar-brand-color);
  text-decoration: none;
  white-space: nowrap;
}
.navbar-brand:hover, .navbar-brand:focus {
  color: var(--bs-navbar-brand-hover-color);
}

.navbar-nav {
  --bs-nav-link-padding-x: 0;
  --bs-nav-link-padding-y: 0.5rem;
  --bs-nav-link-font-weight: ;
  --bs-nav-link-color: var(--bs-navbar-color);
  --bs-nav-link-hover-color: var(--bs-navbar-hover-color);
  --bs-nav-link-disabled-color: var(--bs-navbar-disabled-color);
  display: flex;
  flex-direction: column;
  padding-left: 0;
  margin-bottom: 0;
  list-style: none;
}
.navbar-nav .show > .nav-link,
.navbar-nav .nav-link.active {
  color: var(--bs-navbar-active-color);
}
.navbar-nav .dropdown-menu {
  position: static;
}

.navbar-text {
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
  color: var(--bs-navbar-color);
}
.navbar-text a,
.navbar-text a:hover,
.navbar-text a:focus {
  color: var(--bs-navbar-active-color);
}

.navbar-collapse {
  flex-basis: 100%;
  flex-grow: 1;
  align-items: center;
}

.navbar-toggler {
  padding: var(--bs-navbar-toggler-padding-y) var(--bs-navbar-toggler-padding-x);
  font-size: var(--bs-navbar-toggler-font-size);
  line-height: 1;
  color: var(--bs-navbar-color);
  background-color: transparent;
  border: var(--bs-border-width) solid var(--bs-navbar-toggler-border-color);
  border-radius: var(--bs-navbar-toggler-border-radius);
  transition: var(--bs-navbar-toggler-transition);
}
@media (prefers-reduced-motion: reduce) {
  .navbar-toggler {
    transition: none;
  }
}
.navbar-toggler:hover {
  text-decoration: none;
}
.navbar-toggler:focus {
  text-decoration: none;
  outline: 0;
  box-shadow: 0 0 0 var(--bs-navbar-toggler-focus-width);
}

.navbar-toggler-icon {
  display: inline-block;
  width: 1.5em;
  height: 1.5em;
  vertical-align: middle;
  background-image: var(--bs-navbar-toggler-icon-bg);
  background-repeat: no-repeat;
  background-position: center;
  background-size: 100%;
}

.navbar-nav-scroll {
  max-height: var(--bs-scroll-height, 75vh);
  overflow-y: auto;
}

@media (min-width: 576px) {
  .navbar-expand-sm {
    flex-wrap: nowrap;
    justify-content: flex-start;
  }
  .navbar-expand-sm .navbar-nav {
    flex-direction: row;
  }
  .navbar-expand-sm .navbar-nav .dropdown-menu {
    position: absolute;
  }
  .navbar-expand-sm .navbar-nav .nav-link {
    padding-right: var(--bs-navbar-nav-link-padding-x);
    padding-left: var(--bs-navbar-nav-link-padding-x);
  }
  .navbar-expand-sm .navbar-nav-scroll {
    overflow: visible;
  }
  .navbar-expand-sm .navbar-collapse {
    display: flex !important;
    flex-basis: auto;
  }
  .navbar-expand-sm .navbar-toggler {
    display: none;
  }
  .navbar-expand-sm .offcanvas {
    position: static;
    z-index: auto;
    flex-grow: 1;
    width: auto !important;
    height: auto !important;
    visibility: visible !important;
    background-color: transparent !important;
    border: 0 !important;
    transform: none !important;
    transition: none;
  }
  .navbar-expand-sm .offcanvas .offcanvas-header {
    display: none;
  }
  .navbar-expand-sm .offcanvas .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
  }
}
@media (min-width: 768px) {
  .navbar-expand-md {
    flex-wrap: nowrap;
    justify-content: flex-start;
  }
  .navbar-expand-md .navbar-nav {
    flex-direction: row;
  }
  .navbar-expand-md .navbar-nav .dropdown-menu {
    position: absolute;
  }
  .navbar-expand-md .navbar-nav .nav-link {
    padding-right: var(--bs-navbar-nav-link-padding-x);
    padding-left: var(--bs-navbar-nav-link-padding-x);
  }
  .navbar-expand-md .navbar-nav-scroll {
    overflow: visible;
  }
  .navbar-expand-md .navbar-collapse {
    display: flex !important;
    flex-basis: auto;
  }
  .navbar-expand-md .navbar-toggler {
    display: none;
  }
  .navbar-expand-md .offcanvas {
    position: static;
    z-index: auto;
    flex-grow: 1;
    width: auto !important;
    height: auto !important;
    visibility: visible !important;
    background-color: transparent !important;
    border: 0 !important;
    transform: none !important;
    transition: none;
  }
  .navbar-expand-md .offcanvas .offcanvas-header {
    display: none;
  }
  .navbar-expand-md .offcanvas .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
  }
}
@media (min-width: 992px) {
  .navbar-expand-lg {
    flex-wrap: nowrap;
    justify-content: flex-start;
  }
  .navbar-expand-lg .navbar-nav {
    flex-direction: row;
  }
  .navbar-expand-lg .navbar-nav .dropdown-menu {
    position: absolute;
  }
  .navbar-expand-lg .navbar-nav .nav-link {
    padding-right: var(--bs-navbar-nav-link-padding-x);
    padding-left: var(--bs-navbar-nav-link-padding-x);
  }
  .navbar-expand-lg .navbar-nav-scroll {
    overflow: visible;
  }
  .navbar-expand-lg .navbar-collapse {
    display: flex !important;
    flex-basis: auto;
  }
  .navbar-expand-lg .navbar-toggler {
    display: none;
  }
  .navbar-expand-lg .offcanvas {
    position: static;
    z-index: auto;
    flex-grow: 1;
    width: auto !important;
    height: auto !important;
    visibility: visible !important;
    background-color: transparent !important;
    border: 0 !important;
    transform: none !important;
    transition: none;
  }
  .navbar-expand-lg .offcanvas .offcanvas-header {
    display: none;
  }
  .navbar-expand-lg .offcanvas .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
  }
}
@media (min-width: 1200px) {
  .navbar-expand-xl {
    flex-wrap: nowrap;
    justify-content: flex-start;
  }
  .navbar-expand-xl .navbar-nav {
    flex-direction: row;
  }
  .navbar-expand-xl .navbar-nav .dropdown-menu {
    position: absolute;
  }
  .navbar-expand-xl .navbar-nav .nav-link {
    padding-right: var(--bs-navbar-nav-link-padding-x);
    padding-left: var(--bs-navbar-nav-link-padding-x);
  }
  .navbar-expand-xl .navbar-nav-scroll {
    overflow: visible;
  }
  .navbar-expand-xl .navbar-collapse {
    display: flex !important;
    flex-basis: auto;
  }
  .navbar-expand-xl .navbar-toggler {
    display: none;
  }
  .navbar-expand-xl .offcanvas {
    position: static;
    z-index: auto;
    flex-grow: 1;
    width: auto !important;
    height: auto !important;
    visibility: visible !important;
    background-color: transparent !important;
    border: 0 !important;
    transform: none !important;
    transition: none;
  }
  .navbar-expand-xl .offcanvas .offcanvas-header {
    display: none;
  }
  .navbar-expand-xl .offcanvas .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
  }
}
@media (min-width: 1400px) {
  .navbar-expand-xxl {
    flex-wrap: nowrap;
    justify-content: flex-start;
  }
  .navbar-expand-xxl .navbar-nav {
    flex-direction: row;
  }
  .navbar-expand-xxl .navbar-nav .dropdown-menu {
    position: absolute;
  }
  .navbar-expand-xxl .navbar-nav .nav-link {
    padding-right: var(--bs-navbar-nav-link-padding-x);
    padding-left: var(--bs-navbar-nav-link-padding-x);
  }
  .navbar-expand-xxl .navbar-nav-scroll {
    overflow: visible;
  }
  .navbar-expand-xxl .navbar-collapse {
    display: flex !important;
    flex-basis: auto;
  }
  .navbar-expand-xxl .navbar-toggler {
    display: none;
  }
  .navbar-expand-xxl .offcanvas {
    position: static;
    z-index: auto;
    flex-grow: 1;
    width: auto !important;
    height: auto !important;
    visibility: visible !important;
    background-color: transparent !important;
    border: 0 !important;
    transform: none !important;
    transition: none;
  }
  .navbar-expand-xxl .offcanvas .offcanvas-header {
    display: none;
  }
  .navbar-expand-xxl .offcanvas .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
  }
}
.navbar-expand {
  flex-wrap: nowrap;
  justify-content: flex-start;
}
.navbar-expand .navbar-nav {
  flex-direction: row;
}
.navbar-expand .navbar-nav .dropdown-menu {
  position: absolute;
}
.navbar-expand .navbar-nav .nav-link {
  padding-right: var(--bs-navbar-nav-link-padding-x);
  padding-left: var(--bs-navbar-nav-link-padding-x);
}
.navbar-expand .navbar-nav-scroll {
  overflow: visible;
}
.navbar-expand .navbar-collapse {
  display: flex !important;
  flex-basis: auto;
}
.navbar-expand .navbar-toggler {
  display: none;
}
.navbar-expand .offcanvas {
  position: static;
  z-index: auto;
  flex-grow: 1;
  width: auto !important;
  height: auto !important;
  visibility: visible !important;
  background-color: transparent !important;
  border: 0 !important;
  transform: none !important;
  transition: none;
}
.navbar-expand .offcanvas .offcanvas-header {
  display: none;
}
.navbar-expand .offcanvas .offcanvas-body {
  display: flex;
  flex-grow: 0;
  padding: 0;
  overflow-y: visible;
}

.navbar-dark {
  --bs-navbar-color: rgba(255, 255, 255, 0.55);
  --bs-navbar-hover-color: rgba(255, 255, 255, 0.75);
  --bs-navbar-disabled-color: rgba(255, 255, 255, 0.25);
  --bs-navbar-active-color: #fff;
  --bs-navbar-brand-color: #fff;
  --bs-navbar-brand-hover-color: #fff;
  --bs-navbar-toggler-border-color: rgba(255, 255, 255, 0.1);
  --bs-navbar-toggler-icon-bg: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.55%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
}

.card {
  --bs-card-spacer-y: 1rem;
  --bs-card-spacer-x: 1rem;
  --bs-card-title-spacer-y: 0.5rem;
  --bs-card-border-width: 1px;
  --bs-card-border-color: var(--bs-border-color-translucent);
  --bs-card-border-radius: 0.375rem;
  --bs-card-box-shadow: ;
  --bs-card-inner-border-radius: calc(0.375rem - 1px);
  --bs-card-cap-padding-y: 0.5rem;
  --bs-card-cap-padding-x: 1rem;
  --bs-card-cap-bg: rgba(0, 0, 0, 0.03);
  --bs-card-cap-color: ;
  --bs-card-height: ;
  --bs-card-color: ;
  --bs-card-bg: #fff;
  --bs-card-img-overlay-padding: 1rem;
  --bs-card-group-margin: 0.75rem;
  position: relative;
  display: flex;
  flex-direction: column;
  min-width: 0;
  height: var(--bs-card-height);
  word-wrap: break-word;
  background-color: var(--bs-card-bg);
  background-clip: border-box;
  border: var(--bs-card-border-width) solid var(--bs-card-border-color);
  border-radius: var(--bs-card-border-radius);
}
.card > hr {
  margin-right: 0;
  margin-left: 0;
}
.card > .list-group {
  border-top: inherit;
  border-bottom: inherit;
}
.card > .list-group:first-child {
  border-top-width: 0;
  border-top-left-radius: var(--bs-card-inner-border-radius);
  border-top-right-radius: var(--bs-card-inner-border-radius);
}
.card > .list-group:last-child {
  border-bottom-width: 0;
  border-bottom-right-radius: var(--bs-card-inner-border-radius);
  border-bottom-left-radius: var(--bs-card-inner-border-radius);
}
.card > .card-header + .list-group,
.card > .list-group + .card-footer {
  border-top: 0;
}

.card-body {
  flex: 1 1 auto;
  padding: var(--bs-card-spacer-y) var(--bs-card-spacer-x);
  color: var(--bs-card-color);
}

.card-title {
  margin-bottom: var(--bs-card-title-spacer-y);
}

.card-subtitle {
  margin-top: calc(-0.5 * var(--bs-card-title-spacer-y));
  margin-bottom: 0;
}

.card-text:last-child {
  margin-bottom: 0;
}

.card-link + .card-link {
  margin-left: var(--bs-card-spacer-x);
}

.card-header {
  padding: var(--bs-card-cap-padding-y) var(--bs-card-cap-padding-x);
  margin-bottom: 0;
  color: var(--bs-card-cap-color);
  background-color: var(--bs-card-cap-bg);
  border-bottom: var(--bs-card-border-width) solid var(--bs-card-border-color);
}
.card-header:first-child {
  border-radius: var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius) 0 0;
}

.card-footer {
  padding: var(--bs-card-cap-padding-y) var(--bs-card-cap-padding-x);
  color: var(--bs-card-cap-color);
  background-color: var(--bs-card-cap-bg);
  border-top: var(--bs-card-border-width) solid var(--bs-card-border-color);
}
.card-footer:last-child {
  border-radius: 0 0 var(--bs-card-inner-border-radius) var(--bs-card-inner-border-radius);
}

.card-header-tabs {
  margin-right: calc(-0.5 * var(--bs-card-cap-padding-x));
  margin-bottom: calc(-1 * var(--bs-card-cap-padding-y));
  margin-left: calc(-0.5 * var(--bs-card-cap-padding-x));
  border-bottom: 0;
}
.card-header-tabs .nav-link.active {
  background-color: var(--bs-card-bg);
  border-bottom-color: var(--bs-card-bg);
}

.card-header-pills {
  margin-right: calc(-0.5 * var(--bs-card-cap-padding-x));
  margin-left: calc(-0.5 * var(--bs-card-cap-padding-x));
}

.card-img-overlay {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  padding: var(--bs-card-img-overlay-padding);
  border-radius: var(--bs-card-inner-border-radius);
}

.card-img,
.card-img-top,
.card-img-bottom {
  width: 100%;
}

.card-img,
.card-img-top {
  border-top-left-radius: var(--bs-card-inner-border-radius);
  border-top-right-radius: var(--bs-card-inner-border-radius);
}

.card-img,
.card-img-bottom {
  border-bottom-right-radius: var(--bs-card-inner-border-radius);
  border-bottom-left-radius: var(--bs-card-inner-border-radius);
}

.card-group > .card {
  margin-bottom: var(--bs-card-group-margin);
}
@media (min-width: 576px) {
  .card-group {
    display: flex;
    flex-flow: row wrap;
  }
  .card-group > .card {
    flex: 1 0 0%;
    margin-bottom: 0;
  }
  .card-group > .card + .card {
    margin-left: 0;
    border-left: 0;
  }
  .card-group > .card:not(:last-child) {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
  }
  .card-group > .card:not(:last-child) .card-img-top,
.card-group > .card:not(:last-child) .card-header {
    border-top-right-radius: 0;
  }
  .card-group > .card:not(:last-child) .card-img-bottom,
.card-group > .card:not(:last-child) .card-footer {
    border-bottom-right-radius: 0;
  }
  .card-group > .card:not(:first-child) {
    border-top-left-radius: 0;
    border-bottom-left-radius: 0;
  }
  .card-group > .card:not(:first-child) .card-img-top,
.card-group > .card:not(:first-child) .card-header {
    border-top-left-radius: 0;
  }
  .card-group > .card:not(:first-child) .card-img-bottom,
.card-group > .card:not(:first-child) .card-footer {
    border-bottom-left-radius: 0;
  }
}

.accordion {
  --bs-accordion-color: #212529;
  --bs-accordion-bg: #fff;
  --bs-accordion-transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out, border-radius 0.15s ease;
  --bs-accordion-border-color: var(--bs-border-color);
  --bs-accordion-border-width: 1px;
  --bs-accordion-border-radius: 0.375rem;
  --bs-accordion-inner-border-radius: calc(0.375rem - 1px);
  --bs-accordion-btn-padding-x: 1.25rem;
  --bs-accordion-btn-padding-y: 1rem;
  --bs-accordion-btn-color: #212529;
  --bs-accordion-btn-bg: var(--bs-accordion-bg);
  --bs-accordion-btn-icon: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23212529'%3e%3cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
  --bs-accordion-btn-icon-width: 1.25rem;
  --bs-accordion-btn-icon-transform: rotate(-180deg);
  --bs-accordion-btn-icon-transition: transform 0.2s ease-in-out;
  --bs-accordion-btn-active-icon: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%230c63e4'%3e%3cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
  --bs-accordion-btn-focus-border-color: #86b7fe;
  --bs-accordion-btn-focus-box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
  --bs-accordion-body-padding-x: 1.25rem;
  --bs-accordion-body-padding-y: 1rem;
  --bs-accordion-active-color: #0c63e4;
  --bs-accordion-active-bg: #e7f1ff;
}

.accordion-button {
  position: relative;
  display: flex;
  align-items: center;
  width: 100%;
  padding: var(--bs-accordion-btn-padding-y) var(--bs-accordion-btn-padding-x);
  font-size: 1rem;
  color: var(--bs-accordion-btn-color);
  text-align: left;
  background-color: var(--bs-accordion-btn-bg);
  border: 0;
  border-radius: 0;
  overflow-anchor: none;
  transition: var(--bs-accordion-transition);
}
@media (prefers-reduced-motion: reduce) {
  .accordion-button {
    transition: none;
  }
}
.accordion-button:not(.collapsed) {
  color: var(--bs-accordion-active-color);
  background-color: var(--bs-accordion-active-bg);
  box-shadow: inset 0 calc(-1 * var(--bs-accordion-border-width)) 0 var(--bs-accordion-border-color);
}
.accordion-button:not(.collapsed)::after {
  background-image: var(--bs-accordion-btn-active-icon);
  transform: var(--bs-accordion-btn-icon-transform);
}
.accordion-button::after {
  flex-shrink: 0;
  width: var(--bs-accordion-btn-icon-width);
  height: var(--bs-accordion-btn-icon-width);
  margin-left: auto;
  content: "";
  background-image: var(--bs-accordion-btn-icon);
  background-repeat: no-repeat;
  background-size: var(--bs-accordion-btn-icon-width);
  transition: var(--bs-accordion-btn-icon-transition);
}
@media (prefers-reduced-motion: reduce) {
  .accordion-button::after {
    transition: none;
  }
}
.accordion-button:hover {
  z-index: 2;
}
.accordion-button:focus {
  z-index: 3;
  border-color: var(--bs-accordion-btn-focus-border-color);
  outline: 0;
  box-shadow: var(--bs-accordion-btn-focus-box-shadow);
}

.accordion-header {
  margin-bottom: 0;
}

.accordion-item {
  color: var(--bs-accordion-color);
  background-color: var(--bs-accordion-bg);
  border: var(--bs-accordion-border-width) solid var(--bs-accordion-border-color);
}
.accordion-item:first-of-type {
  border-top-left-radius: var(--bs-accordion-border-radius);
  border-top-right-radius: var(--bs-accordion-border-radius);
}
.accordion-item:first-of-type .accordion-button {
  border-top-left-radius: var(--bs-accordion-inner-border-radius);
  border-top-right-radius: var(--bs-accordion-inner-border-radius);
}
.accordion-item:not(:first-of-type) {
  border-top: 0;
}
.accordion-item:last-of-type {
  border-bottom-right-radius: var(--bs-accordion-border-radius);
  border-bottom-left-radius: var(--bs-accordion-border-radius);
}
.accordion-item:last-of-type .accordion-button.collapsed {
  border-bottom-right-radius: var(--bs-accordion-inner-border-radius);
  border-bottom-left-radius: var(--bs-accordion-inner-border-radius);
}
.accordion-item:last-of-type .accordion-collapse {
  border-bottom-right-radius: var(--bs-accordion-border-radius);
  border-bottom-left-radius: var(--bs-accordion-border-radius);
}

.accordion-body {
  padding: var(--bs-accordion-body-padding-y) var(--bs-accordion-body-padding-x);
}

.accordion-flush .accordion-collapse {
  border-width: 0;
}
.accordion-flush .accordion-item {
  border-right: 0;
  border-left: 0;
  border-radius: 0;
}
.accordion-flush .accordion-item:first-child {
  border-top: 0;
}
.accordion-flush .accordion-item:last-child {
  border-bottom: 0;
}
.accordion-flush .accordion-item .accordion-button, .accordion-flush .accordion-item .accordion-button.collapsed {
  border-radius: 0;
}

.breadcrumb {
  --bs-breadcrumb-padding-x: 0;
  --bs-breadcrumb-padding-y: 0;
  --bs-breadcrumb-margin-bottom: 1rem;
  --bs-breadcrumb-bg: ;
  --bs-breadcrumb-border-radius: ;
  --bs-breadcrumb-divider-color: #6c757d;
  --bs-breadcrumb-item-padding-x: 0.5rem;
  --bs-breadcrumb-item-active-color: #6c757d;
  display: flex;
  flex-wrap: wrap;
  padding: var(--bs-breadcrumb-padding-y) var(--bs-breadcrumb-padding-x);
  margin-bottom: var(--bs-breadcrumb-margin-bottom);
  font-size: var(--bs-breadcrumb-font-size);
  list-style: none;
  background-color: var(--bs-breadcrumb-bg);
  border-radius: var(--bs-breadcrumb-border-radius);
}

.breadcrumb-item + .breadcrumb-item {
  padding-left: var(--bs-breadcrumb-item-padding-x);
}
.breadcrumb-item + .breadcrumb-item::before {
  float: left;
  padding-right: var(--bs-breadcrumb-item-padding-x);
  color: var(--bs-breadcrumb-divider-color);
  content: var(--bs-breadcrumb-divider, "/") /* rtl: var(--bs-breadcrumb-divider, "/") */;
}
.breadcrumb-item.active {
  color: var(--bs-breadcrumb-item-active-color);
}

.pagination {
  --bs-pagination-padding-x: 0.75rem;
  --bs-pagination-padding-y: 0.375rem;
  --bs-pagination-font-size: 1rem;
  --bs-pagination-color: var(--bs-link-color);
  --bs-pagination-bg: #fff;
  --bs-pagination-border-width: 1px;
  --bs-pagination-border-color: #dee2e6;
  --bs-pagination-border-radius: 0.375rem;
  --bs-pagination-hover-color: var(--bs-link-hover-color);
  --bs-pagination-hover-bg: #e9ecef;
  --bs-pagination-hover-border-color: #dee2e6;
  --bs-pagination-focus-color: var(--bs-link-hover-color);
  --bs-pagination-focus-bg: #e9ecef;
  --bs-pagination-focus-box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
  --bs-pagination-active-color: #fff;
  --bs-pagination-active-bg: #0d6efd;
  --bs-pagination-active-border-color: #0d6efd;
  --bs-pagination-disabled-color: #6c757d;
  --bs-pagination-disabled-bg: #fff;
  --bs-pagination-disabled-border-color: #dee2e6;
  display: flex;
  padding-left: 0;
  list-style: none;
}

.page-link {
  position: relative;
  display: block;
  padding: var(--bs-pagination-padding-y) var(--bs-pagination-padding-x);
  font-size: var(--bs-pagination-font-size);
  color: var(--bs-pagination-color);
  text-decoration: none;
  background-color: var(--bs-pagination-bg);
  border: var(--bs-pagination-border-width) solid var(--bs-pagination-border-color);
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .page-link {
    transition: none;
  }
}
.page-link:hover {
  z-index: 2;
  color: var(--bs-pagination-hover-color);
  background-color: var(--bs-pagination-hover-bg);
  border-color: var(--bs-pagination-hover-border-color);
}
.page-link:focus {
  z-index: 3;
  color: var(--bs-pagination-focus-color);
  background-color: var(--bs-pagination-focus-bg);
  outline: 0;
  box-shadow: var(--bs-pagination-focus-box-shadow);
}
.page-link.active, .active > .page-link {
  z-index: 3;
  color: var(--bs-pagination-active-color);
  background-color: var(--bs-pagination-active-bg);
  border-color: var(--bs-pagination-active-border-color);
}
.page-link.disabled, .disabled > .page-link {
  color: var(--bs-pagination-disabled-color);
  pointer-events: none;
  background-color: var(--bs-pagination-disabled-bg);
  border-color: var(--bs-pagination-disabled-border-color);
}

.page-item:not(:first-child) .page-link {
  margin-left: -1px;
}
.page-item:first-child .page-link {
  border-top-left-radius: var(--bs-pagination-border-radius);
  border-bottom-left-radius: var(--bs-pagination-border-radius);
}
.page-item:last-child .page-link {
  border-top-right-radius: var(--bs-pagination-border-radius);
  border-bottom-right-radius: var(--bs-pagination-border-radius);
}

.pagination-lg {
  --bs-pagination-padding-x: 1.5rem;
  --bs-pagination-padding-y: 0.75rem;
  --bs-pagination-font-size: 1.25rem;
  --bs-pagination-border-radius: 0.5rem;
}

.pagination-sm {
  --bs-pagination-padding-x: 0.5rem;
  --bs-pagination-padding-y: 0.25rem;
  --bs-pagination-font-size: 0.875rem;
  --bs-pagination-border-radius: 0.25rem;
}

.badge {
  --bs-badge-padding-x: 0.65em;
  --bs-badge-padding-y: 0.35em;
  --bs-badge-font-size: 0.75em;
  --bs-badge-font-weight: 700;
  --bs-badge-color: #fff;
  --bs-badge-border-radius: 0.375rem;
  display: inline-block;
  padding: var(--bs-badge-padding-y) var(--bs-badge-padding-x);
  font-size: var(--bs-badge-font-size);
  font-weight: var(--bs-badge-font-weight);
  line-height: 1;
  color: var(--bs-badge-color);
  text-align: center;
  white-space: nowrap;
  vertical-align: baseline;
  border-radius: var(--bs-badge-border-radius);
}
.badge:empty {
  display: none;
}

.btn .badge {
  position: relative;
  top: -1px;
}

.alert {
  --bs-alert-bg: transparent;
  --bs-alert-padding-x: 1rem;
  --bs-alert-padding-y: 1rem;
  --bs-alert-margin-bottom: 1rem;
  --bs-alert-color: inherit;
  --bs-alert-border-color: transparent;
  --bs-alert-border: 1px solid var(--bs-alert-border-color);
  --bs-alert-border-radius: 0.375rem;
  position: relative;
  padding: var(--bs-alert-padding-y) var(--bs-alert-padding-x);
  margin-bottom: var(--bs-alert-margin-bottom);
  color: var(--bs-alert-color);
  background-color: var(--bs-alert-bg);
  border: var(--bs-alert-border);
  border-radius: var(--bs-alert-border-radius);
}

.alert-heading {
  color: inherit;
}

.alert-link {
  font-weight: 700;
}

.alert-dismissible {
  padding-right: 3rem;
}
.alert-dismissible .btn-close {
  position: absolute;
  top: 0;
  right: 0;
  z-index: 2;
  padding: 1.25rem 1rem;
}

.alert-primary {
  --bs-alert-color: #084298;
  --bs-alert-bg: #cfe2ff;
  --bs-alert-border-color: #b6d4fe;
}
.alert-primary .alert-link {
  color: #06357a;
}

.alert-secondary {
  --bs-alert-color: #41464b;
  --bs-alert-bg: #e2e3e5;
  --bs-alert-border-color: #d3d6d8;
}
.alert-secondary .alert-link {
  color: #34383c;
}

.alert-success {
  --bs-alert-color: #0f5132;
  --bs-alert-bg: #d1e7dd;
  --bs-alert-border-color: #badbcc;
}
.alert-success .alert-link {
  color: #0c4128;
}

.alert-info {
  --bs-alert-color: #055160;
  --bs-alert-bg: #cff4fc;
  --bs-alert-border-color: #b6effb;
}
.alert-info .alert-link {
  color: #04414d;
}

.alert-warning {
  --bs-alert-color: #664d03;
  --bs-alert-bg: #fff3cd;
  --bs-alert-border-color: #ffecb5;
}
.alert-warning .alert-link {
  color: #523e02;
}

.alert-danger {
  --bs-alert-color: #842029;
  --bs-alert-bg: #f8d7da;
  --bs-alert-border-color: #f5c2c7;
}
.alert-danger .alert-link {
  color: #6a1a21;
}

.alert-light {
  --bs-alert-color: #636464;
  --bs-alert-bg: #fefefe;
  --bs-alert-border-color: #fdfdfe;
}
.alert-light .alert-link {
  color: #4f5050;
}

.alert-dark {
  --bs-alert-color: #141619;
  --bs-alert-bg: #d3d3d4;
  --bs-alert-border-color: #bcbebf;
}
.alert-dark .alert-link {
  color: #101214;
}

@keyframes progress-bar-stripes {
  0% {
    background-position-x: 1rem;
  }
}
.progress {
  --bs-progress-height: 1rem;
  --bs-progress-font-size: 0.75rem;
  --bs-progress-bg: #e9ecef;
  --bs-progress-border-radius: 0.375rem;
  --bs-progress-box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.075);
  --bs-progress-bar-color: #fff;
  --bs-progress-bar-bg: #0d6efd;
  --bs-progress-bar-transition: width 0.6s ease;
  display: flex;
  height: var(--bs-progress-height);
  overflow: hidden;
  font-size: var(--bs-progress-font-size);
  background-color: var(--bs-progress-bg);
  border-radius: var(--bs-progress-border-radius);
}

.progress-bar {
  display: flex;
  flex-direction: column;
  justify-content: center;
  overflow: hidden;
  color: var(--bs-progress-bar-color);
  text-align: center;
  white-space: nowrap;
  background-color: var(--bs-progress-bar-bg);
  transition: var(--bs-progress-bar-transition);
}
@media (prefers-reduced-motion: reduce) {
  .progress-bar {
    transition: none;
  }
}

.progress-bar-striped {
  background-image: linear-gradient(45deg, rgba(255, 255, 255, 0.15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0.15) 75%, transparent 75%, transparent);
  background-size: var(--bs-progress-height) var(--bs-progress-height);
}

.progress-bar-animated {
  animation: 1s linear infinite progress-bar-stripes;
}
@media (prefers-reduced-motion: reduce) {
  .progress-bar-animated {
    animation: none;
  }
}

.list-group {
  --bs-list-group-color: #212529;
  --bs-list-group-bg: #fff;
  --bs-list-group-border-color: rgba(0, 0, 0, 0.125);
  --bs-list-group-border-width: 1px;
  --bs-list-group-border-radius: 0.375rem;
  --bs-list-group-item-padding-x: 1rem;
  --bs-list-group-item-padding-y: 0.5rem;
  --bs-list-group-action-color: #495057;
  --bs-list-group-action-hover-color: #495057;
  --bs-list-group-action-hover-bg: #f8f9fa;
  --bs-list-group-action-active-color: #212529;
  --bs-list-group-action-active-bg: #e9ecef;
  --bs-list-group-disabled-color: #6c757d;
  --bs-list-group-disabled-bg: #fff;
  --bs-list-group-active-color: #fff;
  --bs-list-group-active-bg: #0d6efd;
  --bs-list-group-active-border-color: #0d6efd;
  display: flex;
  flex-direction: column;
  padding-left: 0;
  margin-bottom: 0;
  border-radius: var(--bs-list-group-border-radius);
}

.list-group-numbered {
  list-style-type: none;
  counter-reset: section;
}
.list-group-numbered > .list-group-item::before {
  content: counters(section, ".") ". ";
  counter-increment: section;
}

.list-group-item-action {
  width: 100%;
  color: var(--bs-list-group-action-color);
  text-align: inherit;
}
.list-group-item-action:hover, .list-group-item-action:focus {
  z-index: 1;
  color: var(--bs-list-group-action-hover-color);
  text-decoration: none;
  background-color: var(--bs-list-group-action-hover-bg);
}
.list-group-item-action:active {
  color: var(--bs-list-group-action-active-color);
  background-color: var(--bs-list-group-action-active-bg);
}

.list-group-item {
  position: relative;
  display: block;
  padding: var(--bs-list-group-item-padding-y) var(--bs-list-group-item-padding-x);
  color: var(--bs-list-group-color);
  text-decoration: none;
  background-color: var(--bs-list-group-bg);
  border: var(--bs-list-group-border-width) solid var(--bs-list-group-border-color);
}
.list-group-item:first-child {
  border-top-left-radius: inherit;
  border-top-right-radius: inherit;
}
.list-group-item:last-child {
  border-bottom-right-radius: inherit;
  border-bottom-left-radius: inherit;
}
.list-group-item.disabled, .list-group-item:disabled {
  color: var(--bs-list-group-disabled-color);
  pointer-events: none;
  background-color: var(--bs-list-group-disabled-bg);
}
.list-group-item.active {
  z-index: 2;
  color: var(--bs-list-group-active-color);
  background-color: var(--bs-list-group-active-bg);
  border-color: var(--bs-list-group-active-border-color);
}
.list-group-item + .list-group-item {
  border-top-width: 0;
}
.list-group-item + .list-group-item.active {
  margin-top: calc(-1 * var(--bs-list-group-border-width));
  border-top-width: var(--bs-list-group-border-width);
}

.list-group-horizontal {
  flex-direction: row;
}
.list-group-horizontal > .list-group-item:first-child:not(:last-child) {
  border-bottom-left-radius: var(--bs-list-group-border-radius);
  border-top-right-radius: 0;
}
.list-group-horizontal > .list-group-item:last-child:not(:first-child) {
  border-top-right-radius: var(--bs-list-group-border-radius);
  border-bottom-left-radius: 0;
}
.list-group-horizontal > .list-group-item.active {
  margin-top: 0;
}
.list-group-horizontal > .list-group-item + .list-group-item {
  border-top-width: var(--bs-list-group-border-width);
  border-left-width: 0;
}
.list-group-horizontal > .list-group-item + .list-group-item.active {
  margin-left: calc(-1 * var(--bs-list-group-border-width));
  border-left-width: var(--bs-list-group-border-width);
}

@media (min-width: 576px) {
  .list-group-horizontal-sm {
    flex-direction: row;
  }
  .list-group-horizontal-sm > .list-group-item:first-child:not(:last-child) {
    border-bottom-left-radius: var(--bs-list-group-border-radius);
    border-top-right-radius: 0;
  }
  .list-group-horizontal-sm > .list-group-item:last-child:not(:first-child) {
    border-top-right-radius: var(--bs-list-group-border-radius);
    border-bottom-left-radius: 0;
  }
  .list-group-horizontal-sm > .list-group-item.active {
    margin-top: 0;
  }
  .list-group-horizontal-sm > .list-group-item + .list-group-item {
    border-top-width: var(--bs-list-group-border-width);
    border-left-width: 0;
  }
  .list-group-horizontal-sm > .list-group-item + .list-group-item.active {
    margin-left: calc(-1 * var(--bs-list-group-border-width));
    border-left-width: var(--bs-list-group-border-width);
  }
}
@media (min-width: 768px) {
  .list-group-horizontal-md {
    flex-direction: row;
  }
  .list-group-horizontal-md > .list-group-item:first-child:not(:last-child) {
    border-bottom-left-radius: var(--bs-list-group-border-radius);
    border-top-right-radius: 0;
  }
  .list-group-horizontal-md > .list-group-item:last-child:not(:first-child) {
    border-top-right-radius: var(--bs-list-group-border-radius);
    border-bottom-left-radius: 0;
  }
  .list-group-horizontal-md > .list-group-item.active {
    margin-top: 0;
  }
  .list-group-horizontal-md > .list-group-item + .list-group-item {
    border-top-width: var(--bs-list-group-border-width);
    border-left-width: 0;
  }
  .list-group-horizontal-md > .list-group-item + .list-group-item.active {
    margin-left: calc(-1 * var(--bs-list-group-border-width));
    border-left-width: var(--bs-list-group-border-width);
  }
}
@media (min-width: 992px) {
  .list-group-horizontal-lg {
    flex-direction: row;
  }
  .list-group-horizontal-lg > .list-group-item:first-child:not(:last-child) {
    border-bottom-left-radius: var(--bs-list-group-border-radius);
    border-top-right-radius: 0;
  }
  .list-group-horizontal-lg > .list-group-item:last-child:not(:first-child) {
    border-top-right-radius: var(--bs-list-group-border-radius);
    border-bottom-left-radius: 0;
  }
  .list-group-horizontal-lg > .list-group-item.active {
    margin-top: 0;
  }
  .list-group-horizontal-lg > .list-group-item + .list-group-item {
    border-top-width: var(--bs-list-group-border-width);
    border-left-width: 0;
  }
  .list-group-horizontal-lg > .list-group-item + .list-group-item.active {
    margin-left: calc(-1 * var(--bs-list-group-border-width));
    border-left-width: var(--bs-list-group-border-width);
  }
}
@media (min-width: 1200px) {
  .list-group-horizontal-xl {
    flex-direction: row;
  }
  .list-group-horizontal-xl > .list-group-item:first-child:not(:last-child) {
    border-bottom-left-radius: var(--bs-list-group-border-radius);
    border-top-right-radius: 0;
  }
  .list-group-horizontal-xl > .list-group-item:last-child:not(:first-child) {
    border-top-right-radius: var(--bs-list-group-border-radius);
    border-bottom-left-radius: 0;
  }
  .list-group-horizontal-xl > .list-group-item.active {
    margin-top: 0;
  }
  .list-group-horizontal-xl > .list-group-item + .list-group-item {
    border-top-width: var(--bs-list-group-border-width);
    border-left-width: 0;
  }
  .list-group-horizontal-xl > .list-group-item + .list-group-item.active {
    margin-left: calc(-1 * var(--bs-list-group-border-width));
    border-left-width: var(--bs-list-group-border-width);
  }
}
@media (min-width: 1400px) {
  .list-group-horizontal-xxl {
    flex-direction: row;
  }
  .list-group-horizontal-xxl > .list-group-item:first-child:not(:last-child) {
    border-bottom-left-radius: var(--bs-list-group-border-radius);
    border-top-right-radius: 0;
  }
  .list-group-horizontal-xxl > .list-group-item:last-child:not(:first-child) {
    border-top-right-radius: var(--bs-list-group-border-radius);
    border-bottom-left-radius: 0;
  }
  .list-group-horizontal-xxl > .list-group-item.active {
    margin-top: 0;
  }
  .list-group-horizontal-xxl > .list-group-item + .list-group-item {
    border-top-width: var(--bs-list-group-border-width);
    border-left-width: 0;
  }
  .list-group-horizontal-xxl > .list-group-item + .list-group-item.active {
    margin-left: calc(-1 * var(--bs-list-group-border-width));
    border-left-width: var(--bs-list-group-border-width);
  }
}
.list-group-flush {
  border-radius: 0;
}
.list-group-flush > .list-group-item {
  border-width: 0 0 var(--bs-list-group-border-width);
}
.list-group-flush > .list-group-item:last-child {
  border-bottom-width: 0;
}

.list-group-item-primary {
  color: #084298;
  background-color: #cfe2ff;
}
.list-group-item-primary.list-group-item-action:hover, .list-group-item-primary.list-group-item-action:focus {
  color: #084298;
  background-color: #bacbe6;
}
.list-group-item-primary.list-group-item-action.active {
  color: #fff;
  background-color: #084298;
  border-color: #084298;
}

.list-group-item-secondary {
  color: #41464b;
  background-color: #e2e3e5;
}
.list-group-item-secondary.list-group-item-action:hover, .list-group-item-secondary.list-group-item-action:focus {
  color: #41464b;
  background-color: #cbccce;
}
.list-group-item-secondary.list-group-item-action.active {
  color: #fff;
  background-color: #41464b;
  border-color: #41464b;
}

.list-group-item-success {
  color: #0f5132;
  background-color: #d1e7dd;
}
.list-group-item-success.list-group-item-action:hover, .list-group-item-success.list-group-item-action:focus {
  color: #0f5132;
  background-color: #bcd0c7;
}
.list-group-item-success.list-group-item-action.active {
  color: #fff;
  background-color: #0f5132;
  border-color: #0f5132;
}

.list-group-item-info {
  color: #055160;
  background-color: #cff4fc;
}
.list-group-item-info.list-group-item-action:hover, .list-group-item-info.list-group-item-action:focus {
  color: #055160;
  background-color: #badce3;
}
.list-group-item-info.list-group-item-action.active {
  color: #fff;
  background-color: #055160;
  border-color: #055160;
}

.list-group-item-warning {
  color: #664d03;
  background-color: #fff3cd;
}
.list-group-item-warning.list-group-item-action:hover, .list-group-item-warning.list-group-item-action:focus {
  color: #664d03;
  background-color: #e6dbb9;
}
.list-group-item-warning.list-group-item-action.active {
  color: #fff;
  background-color: #664d03;
  border-color: #664d03;
}

.list-group-item-danger {
  color: #842029;
  background-color: #f8d7da;
}
.list-group-item-danger.list-group-item-action:hover, .list-group-item-danger.list-group-item-action:focus {
  color: #842029;
  background-color: #dfc2c4;
}
.list-group-item-danger.list-group-item-action.active {
  color: #fff;
  background-color: #842029;
  border-color: #842029;
}

.list-group-item-light {
  color: #636464;
  background-color: #fefefe;
}
.list-group-item-light.list-group-item-action:hover, .list-group-item-light.list-group-item-action:focus {
  color: #636464;
  background-color: #e5e5e5;
}
.list-group-item-light.list-group-item-action.active {
  color: #fff;
  background-color: #636464;
  border-color: #636464;
}

.list-group-item-dark {
  color: #141619;
  background-color: #d3d3d4;
}
.list-group-item-dark.list-group-item-action:hover, .list-group-item-dark.list-group-item-action:focus {
  color: #141619;
  background-color: #bebebf;
}
.list-group-item-dark.list-group-item-action.active {
  color: #fff;
  background-color: #141619;
  border-color: #141619;
}

.btn-close {
  box-sizing: content-box;
  width: 1em;
  height: 1em;
  padding: 0.25em 0.25em;
  color: #000;
  background: transparent url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 0 1 1.414 0L8 6.586 14.293.293a1 1 0 1 1 1.414 1.414L9.414 8l6.293 6.293a1 1 0 0 1-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 0 1-1.414-1.414L6.586 8 .293 1.707a1 1 0 0 1 0-1.414z'/%3e%3c/svg%3e") center/1em auto no-repeat;
  border: 0;
  border-radius: 0.375rem;
  opacity: 0.5;
}
.btn-close:hover {
  color: #000;
  text-decoration: none;
  opacity: 0.75;
}
.btn-close:focus {
  outline: 0;
  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
  opacity: 1;
}
.btn-close:disabled, .btn-close.disabled {
  pointer-events: none;
  -webkit-user-select: none;
  -moz-user-select: none;
  user-select: none;
  opacity: 0.25;
}

.btn-close-white {
  filter: invert(1) grayscale(100%) brightness(200%);
}

.toast {
  --bs-toast-zindex: 1090;
  --bs-toast-padding-x: 0.75rem;
  --bs-toast-padding-y: 0.5rem;
  --bs-toast-spacing: 1.5rem;
  --bs-toast-max-width: 350px;
  --bs-toast-font-size: 0.875rem;
  --bs-toast-color: ;
  --bs-toast-bg: rgba(255, 255, 255, 0.85);
  --bs-toast-border-width: 1px;
  --bs-toast-border-color: var(--bs-border-color-translucent);
  --bs-toast-border-radius: 0.375rem;
  --bs-toast-box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  --bs-toast-header-color: #6c757d;
  --bs-toast-header-bg: rgba(255, 255, 255, 0.85);
  --bs-toast-header-border-color: rgba(0, 0, 0, 0.05);
  width: var(--bs-toast-max-width);
  max-width: 100%;
  font-size: var(--bs-toast-font-size);
  color: var(--bs-toast-color);
  pointer-events: auto;
  background-color: var(--bs-toast-bg);
  background-clip: padding-box;
  border: var(--bs-toast-border-width) solid var(--bs-toast-border-color);
  box-shadow: var(--bs-toast-box-shadow);
  border-radius: var(--bs-toast-border-radius);
}
.toast.showing {
  opacity: 0;
}
.toast:not(.show) {
  display: none;
}

.toast-container {
  --bs-toast-zindex: 1090;
  position: absolute;
  z-index: var(--bs-toast-zindex);
  width: -webkit-max-content;
  width: -moz-max-content;
  width: max-content;
  max-width: 100%;
  pointer-events: none;
}
.toast-container > :not(:last-child) {
  margin-bottom: var(--bs-toast-spacing);
}

.toast-header {
  display: flex;
  align-items: center;
  padding: var(--bs-toast-padding-y) var(--bs-toast-padding-x);
  color: var(--bs-toast-header-color);
  background-color: var(--bs-toast-header-bg);
  background-clip: padding-box;
  border-bottom: var(--bs-toast-border-width) solid var(--bs-toast-header-border-color);
  border-top-left-radius: calc(var(--bs-toast-border-radius) - var(--bs-toast-border-width));
  border-top-right-radius: calc(var(--bs-toast-border-radius) - var(--bs-toast-border-width));
}
.toast-header .btn-close {
  margin-right: calc(-0.5 * var(--bs-toast-padding-x));
  margin-left: var(--bs-toast-padding-x);
}

.toast-body {
  padding: var(--bs-toast-padding-x);
  word-wrap: break-word;
}

.modal {
  --bs-modal-zindex: 1055;
  --bs-modal-width: 500px;
  --bs-modal-padding: 1rem;
  --bs-modal-margin: 0.5rem;
  --bs-modal-color: ;
  --bs-modal-bg: #fff;
  --bs-modal-border-color: var(--bs-border-color-translucent);
  --bs-modal-border-width: 1px;
  --bs-modal-border-radius: 0.5rem;
  --bs-modal-box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
  --bs-modal-inner-border-radius: calc(0.5rem - 1px);
  --bs-modal-header-padding-x: 1rem;
  --bs-modal-header-padding-y: 1rem;
  --bs-modal-header-padding: 1rem 1rem;
  --bs-modal-header-border-color: var(--bs-border-color);
  --bs-modal-header-border-width: 1px;
  --bs-modal-title-line-height: 1.5;
  --bs-modal-footer-gap: 0.5rem;
  --bs-modal-footer-bg: ;
  --bs-modal-footer-border-color: var(--bs-border-color);
  --bs-modal-footer-border-width: 1px;
  position: fixed;
  top: 0;
  left: 0;
  z-index: var(--bs-modal-zindex);
  display: none;
  width: 100%;
  height: 100%;
  overflow-x: hidden;
  overflow-y: auto;
  outline: 0;
}

.modal-dialog {
  position: relative;
  width: auto;
  margin: var(--bs-modal-margin);
  pointer-events: none;
}
.modal.fade .modal-dialog {
  transition: transform 0.3s ease-out;
  transform: translate(0, -50px);
}
@media (prefers-reduced-motion: reduce) {
  .modal.fade .modal-dialog {
    transition: none;
  }
}
.modal.show .modal-dialog {
  transform: none;
}
.modal.modal-static .modal-dialog {
  transform: scale(1.02);
}

.modal-dialog-scrollable {
  height: calc(100% - var(--bs-modal-margin) * 2);
}
.modal-dialog-scrollable .modal-content {
  max-height: 100%;
  overflow: hidden;
}
.modal-dialog-scrollable .modal-body {
  overflow-y: auto;
}

.modal-dialog-centered {
  display: flex;
  align-items: center;
  min-height: calc(100% - var(--bs-modal-margin) * 2);
}

.modal-content {
  position: relative;
  display: flex;
  flex-direction: column;
  width: 100%;
  color: var(--bs-modal-color);
  pointer-events: auto;
  background-color: var(--bs-modal-bg);
  background-clip: padding-box;
  border: var(--bs-modal-border-width) solid var(--bs-modal-border-color);
  border-radius: var(--bs-modal-border-radius);
  outline: 0;
}

.modal-backdrop {
  --bs-backdrop-zindex: 1050;
  --bs-backdrop-bg: #000;
  --bs-backdrop-opacity: 0.5;
  position: fixed;
  top: 0;
  left: 0;
  z-index: var(--bs-backdrop-zindex);
  width: 100vw;
  height: 100vh;
  background-color: var(--bs-backdrop-bg);
}
.modal-backdrop.fade {
  opacity: 0;
}
.modal-backdrop.show {
  opacity: var(--bs-backdrop-opacity);
}

.modal-header {
  display: flex;
  flex-shrink: 0;
  align-items: center;
  justify-content: space-between;
  padding: var(--bs-modal-header-padding);
  border-bottom: var(--bs-modal-header-border-width) solid var(--bs-modal-header-border-color);
  border-top-left-radius: var(--bs-modal-inner-border-radius);
  border-top-right-radius: var(--bs-modal-inner-border-radius);
}
.modal-header .btn-close {
  padding: calc(var(--bs-modal-header-padding-y) * 0.5) calc(var(--bs-modal-header-padding-x) * 0.5);
  margin: calc(-0.5 * var(--bs-modal-header-padding-y)) calc(-0.5 * var(--bs-modal-header-padding-x)) calc(-0.5 * var(--bs-modal-header-padding-y)) auto;
}

.modal-title {
  margin-bottom: 0;
  line-height: var(--bs-modal-title-line-height);
}

.modal-body {
  position: relative;
  flex: 1 1 auto;
  padding: var(--bs-modal-padding);
}

.modal-footer {
  display: flex;
  flex-shrink: 0;
  flex-wrap: wrap;
  align-items: center;
  justify-content: flex-end;
  padding: calc(var(--bs-modal-padding) - var(--bs-modal-footer-gap) * 0.5);
  background-color: var(--bs-modal-footer-bg);
  border-top: var(--bs-modal-footer-border-width) solid var(--bs-modal-footer-border-color);
  border-bottom-right-radius: var(--bs-modal-inner-border-radius);
  border-bottom-left-radius: var(--bs-modal-inner-border-radius);
}
.modal-footer > * {
  margin: calc(var(--bs-modal-footer-gap) * 0.5);
}

@media (min-width: 576px) {
  .modal {
    --bs-modal-margin: 1.75rem;
    --bs-modal-box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  }
  .modal-dialog {
    max-width: var(--bs-modal-width);
    margin-right: auto;
    margin-left: auto;
  }
  .modal-sm {
    --bs-modal-width: 300px;
  }
}
@media (min-width: 992px) {
  .modal-lg,
.modal-xl {
    --bs-modal-width: 800px;
  }
}
@media (min-width: 1200px) {
  .modal-xl {
    --bs-modal-width: 1140px;
  }
}
.modal-fullscreen {
  width: 100vw;
  max-width: none;
  height: 100%;
  margin: 0;
}
.modal-fullscreen .modal-content {
  height: 100%;
  border: 0;
  border-radius: 0;
}
.modal-fullscreen .modal-header,
.modal-fullscreen .modal-footer {
  border-radius: 0;
}
.modal-fullscreen .modal-body {
  overflow-y: auto;
}

@media (max-width: 575.98px) {
  .modal-fullscreen-sm-down {
    width: 100vw;
    max-width: none;
    height: 100%;
    margin: 0;
  }
  .modal-fullscreen-sm-down .modal-content {
    height: 100%;
    border: 0;
    border-radius: 0;
  }
  .modal-fullscreen-sm-down .modal-header,
.modal-fullscreen-sm-down .modal-footer {
    border-radius: 0;
  }
  .modal-fullscreen-sm-down .modal-body {
    overflow-y: auto;
  }
}
@media (max-width: 767.98px) {
  .modal-fullscreen-md-down {
    width: 100vw;
    max-width: none;
    height: 100%;
    margin: 0;
  }
  .modal-fullscreen-md-down .modal-content {
    height: 100%;
    border: 0;
    border-radius: 0;
  }
  .modal-fullscreen-md-down .modal-header,
.modal-fullscreen-md-down .modal-footer {
    border-radius: 0;
  }
  .modal-fullscreen-md-down .modal-body {
    overflow-y: auto;
  }
}
@media (max-width: 991.98px) {
  .modal-fullscreen-lg-down {
    width: 100vw;
    max-width: none;
    height: 100%;
    margin: 0;
  }
  .modal-fullscreen-lg-down .modal-content {
    height: 100%;
    border: 0;
    border-radius: 0;
  }
  .modal-fullscreen-lg-down .modal-header,
.modal-fullscreen-lg-down .modal-footer {
    border-radius: 0;
  }
  .modal-fullscreen-lg-down .modal-body {
    overflow-y: auto;
  }
}
@media (max-width: 1199.98px) {
  .modal-fullscreen-xl-down {
    width: 100vw;
    max-width: none;
    height: 100%;
    margin: 0;
  }
  .modal-fullscreen-xl-down .modal-content {
    height: 100%;
    border: 0;
    border-radius: 0;
  }
  .modal-fullscreen-xl-down .modal-header,
.modal-fullscreen-xl-down .modal-footer {
    border-radius: 0;
  }
  .modal-fullscreen-xl-down .modal-body {
    overflow-y: auto;
  }
}
@media (max-width: 1399.98px) {
  .modal-fullscreen-xxl-down {
    width: 100vw;
    max-width: none;
    height: 100%;
    margin: 0;
  }
  .modal-fullscreen-xxl-down .modal-content {
    height: 100%;
    border: 0;
    border-radius: 0;
  }
  .modal-fullscreen-xxl-down .modal-header,
.modal-fullscreen-xxl-down .modal-footer {
    border-radius: 0;
  }
  .modal-fullscreen-xxl-down .modal-body {
    overflow-y: auto;
  }
}
.tooltip {
  --bs-tooltip-zindex: 1080;
  --bs-tooltip-max-width: 200px;
  --bs-tooltip-padding-x: 0.5rem;
  --bs-tooltip-padding-y: 0.25rem;
  --bs-tooltip-margin: ;
  --bs-tooltip-font-size: 0.875rem;
  --bs-tooltip-color: #fff;
  --bs-tooltip-bg: #000;
  --bs-tooltip-border-radius: 0.375rem;
  --bs-tooltip-opacity: 0.9;
  --bs-tooltip-arrow-width: 0.8rem;
  --bs-tooltip-arrow-height: 0.4rem;
  z-index: var(--bs-tooltip-zindex);
  display: block;
  padding: var(--bs-tooltip-arrow-height);
  margin: var(--bs-tooltip-margin);
  font-family: var(--bs-font-sans-serif);
  font-style: normal;
  font-weight: 400;
  line-height: 1.5;
  text-align: left;
  text-align: start;
  text-decoration: none;
  text-shadow: none;
  text-transform: none;
  letter-spacing: normal;
  word-break: normal;
  white-space: normal;
  word-spacing: normal;
  line-break: auto;
  font-size: var(--bs-tooltip-font-size);
  word-wrap: break-word;
  opacity: 0;
}
.tooltip.show {
  opacity: var(--bs-tooltip-opacity);
}
.tooltip .tooltip-arrow {
  display: block;
  width: var(--bs-tooltip-arrow-width);
  height: var(--bs-tooltip-arrow-height);
}
.tooltip .tooltip-arrow::before {
  position: absolute;
  content: "";
  border-color: transparent;
  border-style: solid;
}

.bs-tooltip-top .tooltip-arrow, .bs-tooltip-auto[data-popper-placement^=top] .tooltip-arrow {
  bottom: 0;
}
.bs-tooltip-top .tooltip-arrow::before, .bs-tooltip-auto[data-popper-placement^=top] .tooltip-arrow::before {
  top: -1px;
  border-width: var(--bs-tooltip-arrow-height) calc(var(--bs-tooltip-arrow-width) * 0.5) 0;
  border-top-color: var(--bs-tooltip-bg);
}

/* rtl:begin:ignore */
.bs-tooltip-end .tooltip-arrow, .bs-tooltip-auto[data-popper-placement^=right] .tooltip-arrow {
  left: 0;
  width: var(--bs-tooltip-arrow-height);
  height: var(--bs-tooltip-arrow-width);
}
.bs-tooltip-end .tooltip-arrow::before, .bs-tooltip-auto[data-popper-placement^=right] .tooltip-arrow::before {
  right: -1px;
  border-width: calc(var(--bs-tooltip-arrow-width) * 0.5) var(--bs-tooltip-arrow-height) calc(var(--bs-tooltip-arrow-width) * 0.5) 0;
  border-right-color: var(--bs-tooltip-bg);
}

/* rtl:end:ignore */
.bs-tooltip-bottom .tooltip-arrow, .bs-tooltip-auto[data-popper-placement^=bottom] .tooltip-arrow {
  top: 0;
}
.bs-tooltip-bottom .tooltip-arrow::before, .bs-tooltip-auto[data-popper-placement^=bottom] .tooltip-arrow::before {
  bottom: -1px;
  border-width: 0 calc(var(--bs-tooltip-arrow-width) * 0.5) var(--bs-tooltip-arrow-height);
  border-bottom-color: var(--bs-tooltip-bg);
}

/* rtl:begin:ignore */
.bs-tooltip-start .tooltip-arrow, .bs-tooltip-auto[data-popper-placement^=left] .tooltip-arrow {
  right: 0;
  width: var(--bs-tooltip-arrow-height);
  height: var(--bs-tooltip-arrow-width);
}
.bs-tooltip-start .tooltip-arrow::before, .bs-tooltip-auto[data-popper-placement^=left] .tooltip-arrow::before {
  left: -1px;
  border-width: calc(var(--bs-tooltip-arrow-width) * 0.5) 0 calc(var(--bs-tooltip-arrow-width) * 0.5) var(--bs-tooltip-arrow-height);
  border-left-color: var(--bs-tooltip-bg);
}

/* rtl:end:ignore */
.tooltip-inner {
  max-width: var(--bs-tooltip-max-width);
  padding: var(--bs-tooltip-padding-y) var(--bs-tooltip-padding-x);
  color: var(--bs-tooltip-color);
  text-align: center;
  background-color: var(--bs-tooltip-bg);
  border-radius: var(--bs-tooltip-border-radius);
}

.popover {
  --bs-popover-zindex: 1070;
  --bs-popover-max-width: 276px;
  --bs-popover-font-size: 0.875rem;
  --bs-popover-bg: #fff;
  --bs-popover-border-width: 1px;
  --bs-popover-border-color: var(--bs-border-color-translucent);
  --bs-popover-border-radius: 0.5rem;
  --bs-popover-inner-border-radius: calc(0.5rem - 1px);
  --bs-popover-box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  --bs-popover-header-padding-x: 1rem;
  --bs-popover-header-padding-y: 0.5rem;
  --bs-popover-header-font-size: 1rem;
  --bs-popover-header-color: ;
  --bs-popover-header-bg: #f0f0f0;
  --bs-popover-body-padding-x: 1rem;
  --bs-popover-body-padding-y: 1rem;
  --bs-popover-body-color: #212529;
  --bs-popover-arrow-width: 1rem;
  --bs-popover-arrow-height: 0.5rem;
  --bs-popover-arrow-border: var(--bs-popover-border-color);
  z-index: var(--bs-popover-zindex);
  display: block;
  max-width: var(--bs-popover-max-width);
  font-family: var(--bs-font-sans-serif);
  font-style: normal;
  font-weight: 400;
  line-height: 1.5;
  text-align: left;
  text-align: start;
  text-decoration: none;
  text-shadow: none;
  text-transform: none;
  letter-spacing: normal;
  word-break: normal;
  white-space: normal;
  word-spacing: normal;
  line-break: auto;
  font-size: var(--bs-popover-font-size);
  word-wrap: break-word;
  background-color: var(--bs-popover-bg);
  background-clip: padding-box;
  border: var(--bs-popover-border-width) solid var(--bs-popover-border-color);
  border-radius: var(--bs-popover-border-radius);
}
.popover .popover-arrow {
  display: block;
  width: var(--bs-popover-arrow-width);
  height: var(--bs-popover-arrow-height);
}
.popover .popover-arrow::before, .popover .popover-arrow::after {
  position: absolute;
  display: block;
  content: "";
  border-color: transparent;
  border-style: solid;
  border-width: 0;
}

.bs-popover-top > .popover-arrow, .bs-popover-auto[data-popper-placement^=top] > .popover-arrow {
  bottom: calc(-1 * (var(--bs-popover-arrow-height)) - var(--bs-popover-border-width));
}
.bs-popover-top > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=top] > .popover-arrow::before, .bs-popover-top > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=top] > .popover-arrow::after {
  border-width: var(--bs-popover-arrow-height) calc(var(--bs-popover-arrow-width) * 0.5) 0;
}
.bs-popover-top > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=top] > .popover-arrow::before {
  bottom: 0;
  border-top-color: var(--bs-popover-arrow-border);
}
.bs-popover-top > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=top] > .popover-arrow::after {
  bottom: var(--bs-popover-border-width);
  border-top-color: var(--bs-popover-bg);
}

/* rtl:begin:ignore */
.bs-popover-end > .popover-arrow, .bs-popover-auto[data-popper-placement^=right] > .popover-arrow {
  left: calc(-1 * (var(--bs-popover-arrow-height)) - var(--bs-popover-border-width));
  width: var(--bs-popover-arrow-height);
  height: var(--bs-popover-arrow-width);
}
.bs-popover-end > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=right] > .popover-arrow::before, .bs-popover-end > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=right] > .popover-arrow::after {
  border-width: calc(var(--bs-popover-arrow-width) * 0.5) var(--bs-popover-arrow-height) calc(var(--bs-popover-arrow-width) * 0.5) 0;
}
.bs-popover-end > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=right] > .popover-arrow::before {
  left: 0;
  border-right-color: var(--bs-popover-arrow-border);
}
.bs-popover-end > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=right] > .popover-arrow::after {
  left: var(--bs-popover-border-width);
  border-right-color: var(--bs-popover-bg);
}

/* rtl:end:ignore */
.bs-popover-bottom > .popover-arrow, .bs-popover-auto[data-popper-placement^=bottom] > .popover-arrow {
  top: calc(-1 * (var(--bs-popover-arrow-height)) - var(--bs-popover-border-width));
}
.bs-popover-bottom > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=bottom] > .popover-arrow::before, .bs-popover-bottom > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=bottom] > .popover-arrow::after {
  border-width: 0 calc(var(--bs-popover-arrow-width) * 0.5) var(--bs-popover-arrow-height);
}
.bs-popover-bottom > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=bottom] > .popover-arrow::before {
  top: 0;
  border-bottom-color: var(--bs-popover-arrow-border);
}
.bs-popover-bottom > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=bottom] > .popover-arrow::after {
  top: var(--bs-popover-border-width);
  border-bottom-color: var(--bs-popover-bg);
}
.bs-popover-bottom .popover-header::before, .bs-popover-auto[data-popper-placement^=bottom] .popover-header::before {
  position: absolute;
  top: 0;
  left: 50%;
  display: block;
  width: var(--bs-popover-arrow-width);
  margin-left: calc(-0.5 * var(--bs-popover-arrow-width));
  content: "";
  border-bottom: var(--bs-popover-border-width) solid var(--bs-popover-header-bg);
}

/* rtl:begin:ignore */
.bs-popover-start > .popover-arrow, .bs-popover-auto[data-popper-placement^=left] > .popover-arrow {
  right: calc(-1 * (var(--bs-popover-arrow-height)) - var(--bs-popover-border-width));
  width: var(--bs-popover-arrow-height);
  height: var(--bs-popover-arrow-width);
}
.bs-popover-start > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=left] > .popover-arrow::before, .bs-popover-start > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=left] > .popover-arrow::after {
  border-width: calc(var(--bs-popover-arrow-width) * 0.5) 0 calc(var(--bs-popover-arrow-width) * 0.5) var(--bs-popover-arrow-height);
}
.bs-popover-start > .popover-arrow::before, .bs-popover-auto[data-popper-placement^=left] > .popover-arrow::before {
  right: 0;
  border-left-color: var(--bs-popover-arrow-border);
}
.bs-popover-start > .popover-arrow::after, .bs-popover-auto[data-popper-placement^=left] > .popover-arrow::after {
  right: var(--bs-popover-border-width);
  border-left-color: var(--bs-popover-bg);
}

/* rtl:end:ignore */
.popover-header {
  padding: var(--bs-popover-header-padding-y) var(--bs-popover-header-padding-x);
  margin-bottom: 0;
  font-size: var(--bs-popover-header-font-size);
  color: var(--bs-popover-header-color);
  background-color: var(--bs-popover-header-bg);
  border-bottom: var(--bs-popover-border-width) solid var(--bs-popover-border-color);
  border-top-left-radius: var(--bs-popover-inner-border-radius);
  border-top-right-radius: var(--bs-popover-inner-border-radius);
}
.popover-header:empty {
  display: none;
}

.popover-body {
  padding: var(--bs-popover-body-padding-y) var(--bs-popover-body-padding-x);
  color: var(--bs-popover-body-color);
}

.carousel {
  position: relative;
}

.carousel.pointer-event {
  touch-action: pan-y;
}

.carousel-inner {
  position: relative;
  width: 100%;
  overflow: hidden;
}
.carousel-inner::after {
  display: block;
  clear: both;
  content: "";
}

.carousel-item {
  position: relative;
  display: none;
  float: left;
  width: 100%;
  margin-right: -100%;
  -webkit-backface-visibility: hidden;
  backface-visibility: hidden;
  transition: transform 0.6s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .carousel-item {
    transition: none;
  }
}

.carousel-item.active,
.carousel-item-next,
.carousel-item-prev {
  display: block;
}

/* rtl:begin:ignore */
.carousel-item-next:not(.carousel-item-start),
.active.carousel-item-end {
  transform: translateX(100%);
}

.carousel-item-prev:not(.carousel-item-end),
.active.carousel-item-start {
  transform: translateX(-100%);
}

/* rtl:end:ignore */
.carousel-fade .carousel-item {
  opacity: 0;
  transition-property: opacity;
  transform: none;
}
.carousel-fade .carousel-item.active,
.carousel-fade .carousel-item-next.carousel-item-start,
.carousel-fade .carousel-item-prev.carousel-item-end {
  z-index: 1;
  opacity: 1;
}
.carousel-fade .active.carousel-item-start,
.carousel-fade .active.carousel-item-end {
  z-index: 0;
  opacity: 0;
  transition: opacity 0s 0.6s;
}
@media (prefers-reduced-motion: reduce) {
  .carousel-fade .active.carousel-item-start,
.carousel-fade .active.carousel-item-end {
    transition: none;
  }
}

.carousel-control-prev,
.carousel-control-next {
  position: absolute;
  top: 0;
  bottom: 0;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 15%;
  padding: 0;
  color: #fff;
  text-align: center;
  background: none;
  border: 0;
  opacity: 0.5;
  transition: opacity 0.15s ease;
}
@media (prefers-reduced-motion: reduce) {
  .carousel-control-prev,
.carousel-control-next {
    transition: none;
  }
}
.carousel-control-prev:hover, .carousel-control-prev:focus,
.carousel-control-next:hover,
.carousel-control-next:focus {
  color: #fff;
  text-decoration: none;
  outline: 0;
  opacity: 0.9;
}

.carousel-control-prev {
  left: 0;
}

.carousel-control-next {
  right: 0;
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
  display: inline-block;
  width: 2rem;
  height: 2rem;
  background-repeat: no-repeat;
  background-position: 50%;
  background-size: 100% 100%;
}

/* rtl:options: {
  "autoRename": true,
  "stringMap":[ {
    "name"    : "prev-next",
    "search"  : "prev",
    "replace" : "next"
  } ]
} */
.carousel-control-prev-icon {
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23fff'%3e%3cpath d='M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z'/%3e%3c/svg%3e");
}

.carousel-control-next-icon {
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23fff'%3e%3cpath d='M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
}

.carousel-indicators {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 2;
  display: flex;
  justify-content: center;
  padding: 0;
  margin-right: 15%;
  margin-bottom: 1rem;
  margin-left: 15%;
  list-style: none;
}
.carousel-indicators [data-bs-target] {
  box-sizing: content-box;
  flex: 0 1 auto;
  width: 30px;
  height: 3px;
  padding: 0;
  margin-right: 3px;
  margin-left: 3px;
  text-indent: -999px;
  cursor: pointer;
  background-color: #fff;
  background-clip: padding-box;
  border: 0;
  border-top: 10px solid transparent;
  border-bottom: 10px solid transparent;
  opacity: 0.5;
  transition: opacity 0.6s ease;
}
@media (prefers-reduced-motion: reduce) {
  .carousel-indicators [data-bs-target] {
    transition: none;
  }
}
.carousel-indicators .active {
  opacity: 1;
}

.carousel-caption {
  position: absolute;
  right: 15%;
  bottom: 1.25rem;
  left: 15%;
  padding-top: 1.25rem;
  padding-bottom: 1.25rem;
  color: #fff;
  text-align: center;
}

.carousel-dark .carousel-control-prev-icon,
.carousel-dark .carousel-control-next-icon {
  filter: invert(1) grayscale(100);
}
.carousel-dark .carousel-indicators [data-bs-target] {
  background-color: #000;
}
.carousel-dark .carousel-caption {
  color: #000;
}

.spinner-grow,
.spinner-border {
  display: inline-block;
  width: var(--bs-spinner-width);
  height: var(--bs-spinner-height);
  vertical-align: var(--bs-spinner-vertical-align);
  border-radius: 50%;
  animation: var(--bs-spinner-animation-speed) linear infinite var(--bs-spinner-animation-name);
}

@keyframes spinner-border {
  to {
    transform: rotate(360deg) /* rtl:ignore */;
  }
}
.spinner-border {
  --bs-spinner-width: 2rem;
  --bs-spinner-height: 2rem;
  --bs-spinner-vertical-align: -0.125em;
  --bs-spinner-border-width: 0.25em;
  --bs-spinner-animation-speed: 0.75s;
  --bs-spinner-animation-name: spinner-border;
  border: var(--bs-spinner-border-width) solid currentcolor;
  border-right-color: transparent;
}

.spinner-border-sm {
  --bs-spinner-width: 1rem;
  --bs-spinner-height: 1rem;
  --bs-spinner-border-width: 0.2em;
}

@keyframes spinner-grow {
  0% {
    transform: scale(0);
  }
  50% {
    opacity: 1;
    transform: none;
  }
}
.spinner-grow {
  --bs-spinner-width: 2rem;
  --bs-spinner-height: 2rem;
  --bs-spinner-vertical-align: -0.125em;
  --bs-spinner-animation-speed: 0.75s;
  --bs-spinner-animation-name: spinner-grow;
  background-color: currentcolor;
  opacity: 0;
}

.spinner-grow-sm {
  --bs-spinner-width: 1rem;
  --bs-spinner-height: 1rem;
}

@media (prefers-reduced-motion: reduce) {
  .spinner-border,
.spinner-grow {
    --bs-spinner-animation-speed: 1.5s;
  }
}
.offcanvas, .offcanvas-xxl, .offcanvas-xl, .offcanvas-lg, .offcanvas-md, .offcanvas-sm {
  --bs-offcanvas-zindex: 1045;
  --bs-offcanvas-width: 400px;
  --bs-offcanvas-height: 30vh;
  --bs-offcanvas-padding-x: 1rem;
  --bs-offcanvas-padding-y: 1rem;
  --bs-offcanvas-color: ;
  --bs-offcanvas-bg: #fff;
  --bs-offcanvas-border-width: 1px;
  --bs-offcanvas-border-color: var(--bs-border-color-translucent);
  --bs-offcanvas-box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

@media (max-width: 575.98px) {
  .offcanvas-sm {
    position: fixed;
    bottom: 0;
    z-index: var(--bs-offcanvas-zindex);
    display: flex;
    flex-direction: column;
    max-width: 100%;
    color: var(--bs-offcanvas-color);
    visibility: hidden;
    background-color: var(--bs-offcanvas-bg);
    background-clip: padding-box;
    outline: 0;
    transition: transform 0.3s ease-in-out;
  }
}
@media (max-width: 575.98px) and (prefers-reduced-motion: reduce) {
  .offcanvas-sm {
    transition: none;
  }
}
@media (max-width: 575.98px) {
  .offcanvas-sm.offcanvas-start {
    top: 0;
    left: 0;
    width: var(--bs-offcanvas-width);
    border-right: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(-100%);
  }
}
@media (max-width: 575.98px) {
  .offcanvas-sm.offcanvas-end {
    top: 0;
    right: 0;
    width: var(--bs-offcanvas-width);
    border-left: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(100%);
  }
}
@media (max-width: 575.98px) {
  .offcanvas-sm.offcanvas-top {
    top: 0;
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-bottom: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(-100%);
  }
}
@media (max-width: 575.98px) {
  .offcanvas-sm.offcanvas-bottom {
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-top: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(100%);
  }
}
@media (max-width: 575.98px) {
  .offcanvas-sm.showing, .offcanvas-sm.show:not(.hiding) {
    transform: none;
  }
}
@media (max-width: 575.98px) {
  .offcanvas-sm.showing, .offcanvas-sm.hiding, .offcanvas-sm.show {
    visibility: visible;
  }
}
@media (min-width: 576px) {
  .offcanvas-sm {
    --bs-offcanvas-height: auto;
    --bs-offcanvas-border-width: 0;
    background-color: transparent !important;
  }
  .offcanvas-sm .offcanvas-header {
    display: none;
  }
  .offcanvas-sm .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
    background-color: transparent !important;
  }
}

@media (max-width: 767.98px) {
  .offcanvas-md {
    position: fixed;
    bottom: 0;
    z-index: var(--bs-offcanvas-zindex);
    display: flex;
    flex-direction: column;
    max-width: 100%;
    color: var(--bs-offcanvas-color);
    visibility: hidden;
    background-color: var(--bs-offcanvas-bg);
    background-clip: padding-box;
    outline: 0;
    transition: transform 0.3s ease-in-out;
  }
}
@media (max-width: 767.98px) and (prefers-reduced-motion: reduce) {
  .offcanvas-md {
    transition: none;
  }
}
@media (max-width: 767.98px) {
  .offcanvas-md.offcanvas-start {
    top: 0;
    left: 0;
    width: var(--bs-offcanvas-width);
    border-right: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(-100%);
  }
}
@media (max-width: 767.98px) {
  .offcanvas-md.offcanvas-end {
    top: 0;
    right: 0;
    width: var(--bs-offcanvas-width);
    border-left: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(100%);
  }
}
@media (max-width: 767.98px) {
  .offcanvas-md.offcanvas-top {
    top: 0;
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-bottom: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(-100%);
  }
}
@media (max-width: 767.98px) {
  .offcanvas-md.offcanvas-bottom {
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-top: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(100%);
  }
}
@media (max-width: 767.98px) {
  .offcanvas-md.showing, .offcanvas-md.show:not(.hiding) {
    transform: none;
  }
}
@media (max-width: 767.98px) {
  .offcanvas-md.showing, .offcanvas-md.hiding, .offcanvas-md.show {
    visibility: visible;
  }
}
@media (min-width: 768px) {
  .offcanvas-md {
    --bs-offcanvas-height: auto;
    --bs-offcanvas-border-width: 0;
    background-color: transparent !important;
  }
  .offcanvas-md .offcanvas-header {
    display: none;
  }
  .offcanvas-md .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
    background-color: transparent !important;
  }
}

@media (max-width: 991.98px) {
  .offcanvas-lg {
    position: fixed;
    bottom: 0;
    z-index: var(--bs-offcanvas-zindex);
    display: flex;
    flex-direction: column;
    max-width: 100%;
    color: var(--bs-offcanvas-color);
    visibility: hidden;
    background-color: var(--bs-offcanvas-bg);
    background-clip: padding-box;
    outline: 0;
    transition: transform 0.3s ease-in-out;
  }
}
@media (max-width: 991.98px) and (prefers-reduced-motion: reduce) {
  .offcanvas-lg {
    transition: none;
  }
}
@media (max-width: 991.98px) {
  .offcanvas-lg.offcanvas-start {
    top: 0;
    left: 0;
    width: var(--bs-offcanvas-width);
    border-right: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(-100%);
  }
}
@media (max-width: 991.98px) {
  .offcanvas-lg.offcanvas-end {
    top: 0;
    right: 0;
    width: var(--bs-offcanvas-width);
    border-left: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(100%);
  }
}
@media (max-width: 991.98px) {
  .offcanvas-lg.offcanvas-top {
    top: 0;
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-bottom: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(-100%);
  }
}
@media (max-width: 991.98px) {
  .offcanvas-lg.offcanvas-bottom {
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-top: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(100%);
  }
}
@media (max-width: 991.98px) {
  .offcanvas-lg.showing, .offcanvas-lg.show:not(.hiding) {
    transform: none;
  }
}
@media (max-width: 991.98px) {
  .offcanvas-lg.showing, .offcanvas-lg.hiding, .offcanvas-lg.show {
    visibility: visible;
  }
}
@media (min-width: 992px) {
  .offcanvas-lg {
    --bs-offcanvas-height: auto;
    --bs-offcanvas-border-width: 0;
    background-color: transparent !important;
  }
  .offcanvas-lg .offcanvas-header {
    display: none;
  }
  .offcanvas-lg .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
    background-color: transparent !important;
  }
}

@media (max-width: 1199.98px) {
  .offcanvas-xl {
    position: fixed;
    bottom: 0;
    z-index: var(--bs-offcanvas-zindex);
    display: flex;
    flex-direction: column;
    max-width: 100%;
    color: var(--bs-offcanvas-color);
    visibility: hidden;
    background-color: var(--bs-offcanvas-bg);
    background-clip: padding-box;
    outline: 0;
    transition: transform 0.3s ease-in-out;
  }
}
@media (max-width: 1199.98px) and (prefers-reduced-motion: reduce) {
  .offcanvas-xl {
    transition: none;
  }
}
@media (max-width: 1199.98px) {
  .offcanvas-xl.offcanvas-start {
    top: 0;
    left: 0;
    width: var(--bs-offcanvas-width);
    border-right: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(-100%);
  }
}
@media (max-width: 1199.98px) {
  .offcanvas-xl.offcanvas-end {
    top: 0;
    right: 0;
    width: var(--bs-offcanvas-width);
    border-left: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(100%);
  }
}
@media (max-width: 1199.98px) {
  .offcanvas-xl.offcanvas-top {
    top: 0;
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-bottom: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(-100%);
  }
}
@media (max-width: 1199.98px) {
  .offcanvas-xl.offcanvas-bottom {
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-top: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(100%);
  }
}
@media (max-width: 1199.98px) {
  .offcanvas-xl.showing, .offcanvas-xl.show:not(.hiding) {
    transform: none;
  }
}
@media (max-width: 1199.98px) {
  .offcanvas-xl.showing, .offcanvas-xl.hiding, .offcanvas-xl.show {
    visibility: visible;
  }
}
@media (min-width: 1200px) {
  .offcanvas-xl {
    --bs-offcanvas-height: auto;
    --bs-offcanvas-border-width: 0;
    background-color: transparent !important;
  }
  .offcanvas-xl .offcanvas-header {
    display: none;
  }
  .offcanvas-xl .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
    background-color: transparent !important;
  }
}

@media (max-width: 1399.98px) {
  .offcanvas-xxl {
    position: fixed;
    bottom: 0;
    z-index: var(--bs-offcanvas-zindex);
    display: flex;
    flex-direction: column;
    max-width: 100%;
    color: var(--bs-offcanvas-color);
    visibility: hidden;
    background-color: var(--bs-offcanvas-bg);
    background-clip: padding-box;
    outline: 0;
    transition: transform 0.3s ease-in-out;
  }
}
@media (max-width: 1399.98px) and (prefers-reduced-motion: reduce) {
  .offcanvas-xxl {
    transition: none;
  }
}
@media (max-width: 1399.98px) {
  .offcanvas-xxl.offcanvas-start {
    top: 0;
    left: 0;
    width: var(--bs-offcanvas-width);
    border-right: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(-100%);
  }
}
@media (max-width: 1399.98px) {
  .offcanvas-xxl.offcanvas-end {
    top: 0;
    right: 0;
    width: var(--bs-offcanvas-width);
    border-left: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateX(100%);
  }
}
@media (max-width: 1399.98px) {
  .offcanvas-xxl.offcanvas-top {
    top: 0;
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-bottom: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(-100%);
  }
}
@media (max-width: 1399.98px) {
  .offcanvas-xxl.offcanvas-bottom {
    right: 0;
    left: 0;
    height: var(--bs-offcanvas-height);
    max-height: 100%;
    border-top: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
    transform: translateY(100%);
  }
}
@media (max-width: 1399.98px) {
  .offcanvas-xxl.showing, .offcanvas-xxl.show:not(.hiding) {
    transform: none;
  }
}
@media (max-width: 1399.98px) {
  .offcanvas-xxl.showing, .offcanvas-xxl.hiding, .offcanvas-xxl.show {
    visibility: visible;
  }
}
@media (min-width: 1400px) {
  .offcanvas-xxl {
    --bs-offcanvas-height: auto;
    --bs-offcanvas-border-width: 0;
    background-color: transparent !important;
  }
  .offcanvas-xxl .offcanvas-header {
    display: none;
  }
  .offcanvas-xxl .offcanvas-body {
    display: flex;
    flex-grow: 0;
    padding: 0;
    overflow-y: visible;
    background-color: transparent !important;
  }
}

.offcanvas {
  position: fixed;
  bottom: 0;
  z-index: var(--bs-offcanvas-zindex);
  display: flex;
  flex-direction: column;
  max-width: 100%;
  color: var(--bs-offcanvas-color);
  visibility: hidden;
  background-color: var(--bs-offcanvas-bg);
  background-clip: padding-box;
  outline: 0;
  transition: transform 0.3s ease-in-out;
}
@media (prefers-reduced-motion: reduce) {
  .offcanvas {
    transition: none;
  }
}
.offcanvas.offcanvas-start {
  top: 0;
  left: 0;
  width: var(--bs-offcanvas-width);
  border-right: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
  transform: translateX(-100%);
}
.offcanvas.offcanvas-end {
  top: 0;
  right: 0;
  width: var(--bs-offcanvas-width);
  border-left: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
  transform: translateX(100%);
}
.offcanvas.offcanvas-top {
  top: 0;
  right: 0;
  left: 0;
  height: var(--bs-offcanvas-height);
  max-height: 100%;
  border-bottom: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
  transform: translateY(-100%);
}
.offcanvas.offcanvas-bottom {
  right: 0;
  left: 0;
  height: var(--bs-offcanvas-height);
  max-height: 100%;
  border-top: var(--bs-offcanvas-border-width) solid var(--bs-offcanvas-border-color);
  transform: translateY(100%);
}
.offcanvas.showing, .offcanvas.show:not(.hiding) {
  transform: none;
}
.offcanvas.showing, .offcanvas.hiding, .offcanvas.show {
  visibility: visible;
}

.offcanvas-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 1040;
  width: 100vw;
  height: 100vh;
  background-color: #000;
}
.offcanvas-backdrop.fade {
  opacity: 0;
}
.offcanvas-backdrop.show {
  opacity: 0.5;
}

.offcanvas-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--bs-offcanvas-padding-y) var(--bs-offcanvas-padding-x);
}
.offcanvas-header .btn-close {
  padding: calc(var(--bs-offcanvas-padding-y) * 0.5) calc(var(--bs-offcanvas-padding-x) * 0.5);
  margin-top: calc(-0.5 * var(--bs-offcanvas-padding-y));
  margin-right: calc(-0.5 * var(--bs-offcanvas-padding-x));
  margin-bottom: calc(-0.5 * var(--bs-offcanvas-padding-y));
}

.offcanvas-title {
  margin-bottom: 0;
  line-height: 1.5;
}

.offcanvas-body {
  flex-grow: 1;
  padding: var(--bs-offcanvas-padding-y) var(--bs-offcanvas-padding-x);
  overflow-y: auto;
}

.placeholder {
  display: inline-block;
  min-height: 1em;
  vertical-align: middle;
  cursor: wait;
  background-color: currentcolor;
  opacity: 0.5;
}
.placeholder.btn::before {
  display: inline-block;
  content: "";
}

.placeholder-xs {
  min-height: 0.6em;
}

.placeholder-sm {
  min-height: 0.8em;
}

.placeholder-lg {
  min-height: 1.2em;
}

.placeholder-glow .placeholder {
  animation: placeholder-glow 2s ease-in-out infinite;
}

@keyframes placeholder-glow {
  50% {
    opacity: 0.2;
  }
}
.placeholder-wave {
  -webkit-mask-image: linear-gradient(130deg, #000 55%, rgba(0, 0, 0, 0.8) 75%, #000 95%);
  mask-image: linear-gradient(130deg, #000 55%, rgba(0, 0, 0, 0.8) 75%, #000 95%);
  -webkit-mask-size: 200% 100%;
  mask-size: 200% 100%;
  animation: placeholder-wave 2s linear infinite;
}

@keyframes placeholder-wave {
  100% {
    -webkit-mask-position: -200% 0%;
    mask-position: -200% 0%;
  }
}
.clearfix::after {
  display: block;
  clear: both;
  content: "";
}

.text-bg-primary {
  color: #fff !important;
  background-color: RGBA(13, 110, 253, var(--bs-bg-opacity, 1)) !important;
}

.text-bg-secondary {
  color: #fff !important;
  background-color: RGBA(108, 117, 125, var(--bs-bg-opacity, 1)) !important;
}

.text-bg-success {
  color: #fff !important;
  background-color: RGBA(25, 135, 84, var(--bs-bg-opacity, 1)) !important;
}

.text-bg-info {
  color: #000 !important;
  background-color: RGBA(13, 202, 240, var(--bs-bg-opacity, 1)) !important;
}

.text-bg-warning {
  color: #000 !important;
  background-color: RGBA(255, 193, 7, var(--bs-bg-opacity, 1)) !important;
}

.text-bg-danger {
  color: #fff !important;
  background-color: RGBA(220, 53, 69, var(--bs-bg-opacity, 1)) !important;
}

.text-bg-light {
  color: #000 !important;
  background-color: RGBA(248, 249, 250, var(--bs-bg-opacity, 1)) !important;
}

.text-bg-dark {
  color: #fff !important;
  background-color: RGBA(33, 37, 41, var(--bs-bg-opacity, 1)) !important;
}

.link-primary {
  color: #0d6efd !important;
}
.link-primary:hover, .link-primary:focus {
  color: #0a58ca !important;
}

.link-secondary {
  color: #6c757d !important;
}
.link-secondary:hover, .link-secondary:focus {
  color: #565e64 !important;
}

.link-success {
  color: #198754 !important;
}
.link-success:hover, .link-success:focus {
  color: #146c43 !important;
}

.link-info {
  color: #0dcaf0 !important;
}
.link-info:hover, .link-info:focus {
  color: #3dd5f3 !important;
}

.link-warning {
  color: #ffc107 !important;
}
.link-warning:hover, .link-warning:focus {
  color: #ffcd39 !important;
}

.link-danger {
  color: #dc3545 !important;
}
.link-danger:hover, .link-danger:focus {
  color: #b02a37 !important;
}

.link-light {
  color: #f8f9fa !important;
}
.link-light:hover, .link-light:focus {
  color: #f9fafb !important;
}

.link-dark {
  color: #212529 !important;
}
.link-dark:hover, .link-dark:focus {
  color: #1a1e21 !important;
}

.ratio {
  position: relative;
  width: 100%;
}
.ratio::before {
  display: block;
  padding-top: var(--bs-aspect-ratio);
  content: "";
}
.ratio > * {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.ratio-1x1 {
  --bs-aspect-ratio: 100%;
}

.ratio-4x3 {
  --bs-aspect-ratio: 75%;
}

.ratio-16x9 {
  --bs-aspect-ratio: 56.25%;
}

.ratio-21x9 {
  --bs-aspect-ratio: 42.8571428571%;
}

.fixed-top {
  position: fixed;
  top: 0;
  right: 0;
  left: 0;
  z-index: 1030;
}

.fixed-bottom {
  position: fixed;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1030;
}

.sticky-top {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  z-index: 1020;
}

.sticky-bottom {
  position: -webkit-sticky;
  position: sticky;
  bottom: 0;
  z-index: 1020;
}

@media (min-width: 576px) {
  .sticky-sm-top {
    position: -webkit-sticky;
    position: sticky;
    top: 0;
    z-index: 1020;
  }
  .sticky-sm-bottom {
    position: -webkit-sticky;
    position: sticky;
    bottom: 0;
    z-index: 1020;
  }
}
@media (min-width: 768px) {
  .sticky-md-top {
    position: -webkit-sticky;
    position: sticky;
    top: 0;
    z-index: 1020;
  }
  .sticky-md-bottom {
    position: -webkit-sticky;
    position: sticky;
    bottom: 0;
    z-index: 1020;
  }
}
@media (min-width: 992px) {
  .sticky-lg-top {
    position: -webkit-sticky;
    position: sticky;
    top: 0;
    z-index: 1020;
  }
  .sticky-lg-bottom {
    position: -webkit-sticky;
    position: sticky;
    bottom: 0;
    z-index: 1020;
  }
}
@media (min-width: 1200px) {
  .sticky-xl-top {
    position: -webkit-sticky;
    position: sticky;
    top: 0;
    z-index: 1020;
  }
  .sticky-xl-bottom {
    position: -webkit-sticky;
    position: sticky;
    bottom: 0;
    z-index: 1020;
  }
}
@media (min-width: 1400px) {
  .sticky-xxl-top {
    position: -webkit-sticky;
    position: sticky;
    top: 0;
    z-index: 1020;
  }
  .sticky-xxl-bottom {
    position: -webkit-sticky;
    position: sticky;
    bottom: 0;
    z-index: 1020;
  }
}
.hstack {
  display: flex;
  flex-direction: row;
  align-items: center;
  align-self: stretch;
}

.vstack {
  display: flex;
  flex: 1 1 auto;
  flex-direction: column;
  align-self: stretch;
}

.visually-hidden,
.visually-hidden-focusable:not(:focus):not(:focus-within) {
  position: absolute !important;
  width: 1px !important;
  height: 1px !important;
  padding: 0 !important;
  margin: -1px !important;
  overflow: hidden !important;
  clip: rect(0, 0, 0, 0) !important;
  white-space: nowrap !important;
  border: 0 !important;
}

.stretched-link::after {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1;
  content: "";
}

.text-truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.vr {
  display: inline-block;
  align-self: stretch;
  width: 1px;
  min-height: 1em;
  background-color: currentcolor;
  opacity: 0.25;
}

.align-baseline {
  vertical-align: baseline !important;
}

.align-top {
  vertical-align: top !important;
}

.align-middle {
  vertical-align: middle !important;
}

.align-bottom {
  vertical-align: bottom !important;
}

.align-text-bottom {
  vertical-align: text-bottom !important;
}

.align-text-top {
  vertical-align: text-top !important;
}

.float-start {
  float: left !important;
}

.float-end {
  float: right !important;
}

.float-none {
  float: none !important;
}

.opacity-0 {
  opacity: 0 !important;
}

.opacity-25 {
  opacity: 0.25 !important;
}

.opacity-50 {
  opacity: 0.5 !important;
}

.opacity-75 {
  opacity: 0.75 !important;
}

.opacity-100 {
  opacity: 1 !important;
}

.overflow-auto {
  overflow: auto !important;
}

.overflow-hidden {
  overflow: hidden !important;
}

.overflow-visible {
  overflow: visible !important;
}

.overflow-scroll {
  overflow: scroll !important;
}

.d-inline {
  display: inline !important;
}

.d-inline-block {
  display: inline-block !important;
}

.d-block {
  display: block !important;
}

.d-grid {
  display: grid !important;
}

.d-table {
  display: table !important;
}

.d-table-row {
  display: table-row !important;
}

.d-table-cell {
  display: table-cell !important;
}

.d-flex {
  display: flex !important;
}

.d-inline-flex {
  display: inline-flex !important;
}

.d-none {
  display: none !important;
}

.shadow {
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
}

.shadow-sm {
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075) !important;
}

.shadow-lg {
  box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.175) !important;
}

.shadow-none {
  box-shadow: none !important;
}

.position-static {
  position: static !important;
}

.position-relative {
  position: relative !important;
}

.position-absolute {
  position: absolute !important;
}

.position-fixed {
  position: fixed !important;
}

.position-sticky {
  position: -webkit-sticky !important;
  position: sticky !important;
}

.top-0 {
  top: 0 !important;
}

.top-50 {
  top: 50% !important;
}

.top-100 {
  top: 100% !important;
}

.bottom-0 {
  bottom: 0 !important;
}

.bottom-50 {
  bottom: 50% !important;
}

.bottom-100 {
  bottom: 100% !important;
}

.start-0 {
  left: 0 !important;
}

.start-50 {
  left: 50% !important;
}

.start-100 {
  left: 100% !important;
}

.end-0 {
  right: 0 !important;
}

.end-50 {
  right: 50% !important;
}

.end-100 {
  right: 100% !important;
}

.translate-middle {
  transform: translate(-50%, -50%) !important;
}

.translate-middle-x {
  transform: translateX(-50%) !important;
}

.translate-middle-y {
  transform: translateY(-50%) !important;
}

.border {
  border: var(--bs-border-width) var(--bs-border-style) var(--bs-border-color) !important;
}

.border-0 {
  border: 0 !important;
}

.border-top {
  border-top: var(--bs-border-width) var(--bs-border-style) var(--bs-border-color) !important;
}

.border-top-0 {
  border-top: 0 !important;
}

.border-end {
  border-right: var(--bs-border-width) var(--bs-border-style) var(--bs-border-color) !important;
}

.border-end-0 {
  border-right: 0 !important;
}

.border-bottom {
  border-bottom: var(--bs-border-width) var(--bs-border-style) var(--bs-border-color) !important;
}

.border-bottom-0 {
  border-bottom: 0 !important;
}

.border-start {
  border-left: var(--bs-border-width) var(--bs-border-style) var(--bs-border-color) !important;
}

.border-start-0 {
  border-left: 0 !important;
}

.border-primary {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-primary-rgb), var(--bs-border-opacity)) !important;
}

.border-secondary {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-secondary-rgb), var(--bs-border-opacity)) !important;
}

.border-success {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-success-rgb), var(--bs-border-opacity)) !important;
}

.border-info {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-info-rgb), var(--bs-border-opacity)) !important;
}

.border-warning {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-warning-rgb), var(--bs-border-opacity)) !important;
}

.border-danger {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-danger-rgb), var(--bs-border-opacity)) !important;
}

.border-light {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-light-rgb), var(--bs-border-opacity)) !important;
}

.border-dark {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-dark-rgb), var(--bs-border-opacity)) !important;
}

.border-white {
  --bs-border-opacity: 1;
  border-color: rgba(var(--bs-white-rgb), var(--bs-border-opacity)) !important;
}

.border-1 {
  --bs-border-width: 1px;
}

.border-2 {
  --bs-border-width: 2px;
}

.border-3 {
  --bs-border-width: 3px;
}

.border-4 {
  --bs-border-width: 4px;
}

.border-5 {
  --bs-border-width: 5px;
}

.border-opacity-10 {
  --bs-border-opacity: 0.1;
}

.border-opacity-25 {
  --bs-border-opacity: 0.25;
}

.border-opacity-50 {
  --bs-border-opacity: 0.5;
}

.border-opacity-75 {
  --bs-border-opacity: 0.75;
}

.border-opacity-100 {
  --bs-border-opacity: 1;
}

.w-25 {
  width: 25% !important;
}

.w-50 {
  width: 50% !important;
}

.w-75 {
  width: 75% !important;
}

.w-100 {
  width: 100% !important;
}

.w-auto {
  width: auto !important;
}

.mw-100 {
  max-width: 100% !important;
}

.vw-100 {
  width: 100vw !important;
}

.min-vw-100 {
  min-width: 100vw !important;
}

.h-25 {
  height: 25% !important;
}

.h-50 {
  height: 50% !important;
}

.h-75 {
  height: 75% !important;
}

.h-100 {
  height: 100% !important;
}

.h-auto {
  height: auto !important;
}

.mh-100 {
  max-height: 100% !important;
}

.vh-100 {
  height: 100vh !important;
}

.min-vh-100 {
  min-height: 100vh !important;
}

.flex-fill {
  flex: 1 1 auto !important;
}

.flex-row {
  flex-direction: row !important;
}

.flex-column {
  flex-direction: column !important;
}

.flex-row-reverse {
  flex-direction: row-reverse !important;
}

.flex-column-reverse {
  flex-direction: column-reverse !important;
}

.flex-grow-0 {
  flex-grow: 0 !important;
}

.flex-grow-1 {
  flex-grow: 1 !important;
}

.flex-shrink-0 {
  flex-shrink: 0 !important;
}

.flex-shrink-1 {
  flex-shrink: 1 !important;
}

.flex-wrap {
  flex-wrap: wrap !important;
}

.flex-nowrap {
  flex-wrap: nowrap !important;
}

.flex-wrap-reverse {
  flex-wrap: wrap-reverse !important;
}

.justify-content-start {
  justify-content: flex-start !important;
}

.justify-content-end {
  justify-content: flex-end !important;
}

.justify-content-center {
  justify-content: center !important;
}

.justify-content-between {
  justify-content: space-between !important;
}

.justify-content-around {
  justify-content: space-around !important;
}

.justify-content-evenly {
  justify-content: space-evenly !important;
}

.align-items-start {
  align-items: flex-start !important;
}

.align-items-end {
  align-items: flex-end !important;
}

.align-items-center {
  align-items: center !important;
}

.align-items-baseline {
  align-items: baseline !important;
}

.align-items-stretch {
  align-items: stretch !important;
}

.align-content-start {
  align-content: flex-start !important;
}

.align-content-end {
  align-content: flex-end !important;
}

.align-content-center {
  align-content: center !important;
}

.align-content-between {
  align-content: space-between !important;
}

.align-content-around {
  align-content: space-around !important;
}

.align-content-stretch {
  align-content: stretch !important;
}

.align-self-auto {
  align-self: auto !important;
}

.align-self-start {
  align-self: flex-start !important;
}

.align-self-end {
  align-self: flex-end !important;
}

.align-self-center {
  align-self: center !important;
}

.align-self-baseline {
  align-self: baseline !important;
}

.align-self-stretch {
  align-self: stretch !important;
}

.order-first {
  order: -1 !important;
}

.order-0 {
  order: 0 !important;
}

.order-1 {
  order: 1 !important;
}

.order-2 {
  order: 2 !important;
}

.order-3 {
  order: 3 !important;
}

.order-4 {
  order: 4 !important;
}

.order-5 {
  order: 5 !important;
}

.order-last {
  order: 6 !important;
}

.m-0 {
  margin: 0 !important;
}

.m-1 {
  margin: 0.25rem !important;
}

.m-2 {
  margin: 0.5rem !important;
}

.m-3 {
  margin: 1rem !important;
}

.m-4 {
  margin: 1.5rem !important;
}

.m-5 {
  margin: 3rem !important;
}

.m-auto {
  margin: auto !important;
}

.mx-0 {
  margin-right: 0 !important;
  margin-left: 0 !important;
}

.mx-1 {
  margin-right: 0.25rem !important;
  margin-left: 0.25rem !important;
}

.mx-2 {
  margin-right: 0.5rem !important;
  margin-left: 0.5rem !important;
}

.mx-3 {
  margin-right: 1rem !important;
  margin-left: 1rem !important;
}

.mx-4 {
  margin-right: 1.5rem !important;
  margin-left: 1.5rem !important;
}

.mx-5 {
  margin-right: 3rem !important;
  margin-left: 3rem !important;
}

.mx-auto {
  margin-right: auto !important;
  margin-left: auto !important;
}

.my-0 {
  margin-top: 0 !important;
  margin-bottom: 0 !important;
}

.my-1 {
  margin-top: 0.25rem !important;
  margin-bottom: 0.25rem !important;
}

.my-2 {
  margin-top: 0.5rem !important;
  margin-bottom: 0.5rem !important;
}

.my-3 {
  margin-top: 1rem !important;
  margin-bottom: 1rem !important;
}

.my-4 {
  margin-top: 1.5rem !important;
  margin-bottom: 1.5rem !important;
}

.my-5 {
  margin-top: 3rem !important;
  margin-bottom: 3rem !important;
}

.my-auto {
  margin-top: auto !important;
  margin-bottom: auto !important;
}

.mt-0 {
  margin-top: 0 !important;
}

.mt-1 {
  margin-top: 0.25rem !important;
}

.mt-2 {
  margin-top: 0.5rem !important;
}

.mt-3 {
  margin-top: 1rem !important;
}

.mt-4 {
  margin-top: 1.5rem !important;
}

.mt-5 {
  margin-top: 3rem !important;
}

.mt-auto {
  margin-top: auto !important;
}

.me-0 {
  margin-right: 0 !important;
}

.me-1 {
  margin-right: 0.25rem !important;
}

.me-2 {
  margin-right: 0.5rem !important;
}

.me-3 {
  margin-right: 1rem !important;
}

.me-4 {
  margin-right: 1.5rem !important;
}

.me-5 {
  margin-right: 3rem !important;
}

.me-auto {
  margin-right: auto !important;
}

.mb-0 {
  margin-bottom: 0 !important;
}

.mb-1 {
  margin-bottom: 0.25rem !important;
}

.mb-2 {
  margin-bottom: 0.5rem !important;
}

.mb-3 {
  margin-bottom: 1rem !important;
}

.mb-4 {
  margin-bottom: 1.5rem !important;
}

.mb-5 {
  margin-bottom: 3rem !important;
}

.mb-auto {
  margin-bottom: auto !important;
}

.ms-0 {
  margin-left: 0 !important;
}

.ms-1 {
  margin-left: 0.25rem !important;
}

.ms-2 {
  margin-left: 0.5rem !important;
}

.ms-3 {
  margin-left: 1rem !important;
}

.ms-4 {
  margin-left: 1.5rem !important;
}

.ms-5 {
  margin-left: 3rem !important;
}

.ms-auto {
  margin-left: auto !important;
}

.p-0 {
  padding: 0 !important;
}

.p-1 {
  padding: 0.25rem !important;
}

.p-2 {
  padding: 0.5rem !important;
}

.p-3 {
  padding: 1rem !important;
}

.p-4 {
  padding: 1.5rem !important;
}

.p-5 {
  padding: 3rem !important;
}

.px-0 {
  padding-right: 0 !important;
  padding-left: 0 !important;
}

.px-1 {
  padding-right: 0.25rem !important;
  padding-left: 0.25rem !important;
}

.px-2 {
  padding-right: 0.5rem !important;
  padding-left: 0.5rem !important;
}

.px-3 {
  padding-right: 1rem !important;
  padding-left: 1rem !important;
}

.px-4 {
  padding-right: 1.5rem !important;
  padding-left: 1.5rem !important;
}

.px-5 {
  padding-right: 3rem !important;
  padding-left: 3rem !important;
}

.py-0 {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
}

.py-1 {
  padding-top: 0.25rem !important;
  padding-bottom: 0.25rem !important;
}

.py-2 {
  padding-top: 0.5rem !important;
  padding-bottom: 0.5rem !important;
}

.py-3 {
  padding-top: 1rem !important;
  padding-bottom: 1rem !important;
}

.py-4 {
  padding-top: 1.5rem !important;
  padding-bottom: 1.5rem !important;
}

.py-5 {
  padding-top: 3rem !important;
  padding-bottom: 3rem !important;
}

.pt-0 {
  padding-top: 0 !important;
}

.pt-1 {
  padding-top: 0.25rem !important;
}

.pt-2 {
  padding-top: 0.5rem !important;
}

.pt-3 {
  padding-top: 1rem !important;
}

.pt-4 {
  padding-top: 1.5rem !important;
}

.pt-5 {
  padding-top: 3rem !important;
}

.pe-0 {
  padding-right: 0 !important;
}

.pe-1 {
  padding-right: 0.25rem !important;
}

.pe-2 {
  padding-right: 0.5rem !important;
}

.pe-3 {
  padding-right: 1rem !important;
}

.pe-4 {
  padding-right: 1.5rem !important;
}

.pe-5 {
  padding-right: 3rem !important;
}

.pb-0 {
  padding-bottom: 0 !important;
}

.pb-1 {
  padding-bottom: 0.25rem !important;
}

.pb-2 {
  padding-bottom: 0.5rem !important;
}

.pb-3 {
  padding-bottom: 1rem !important;
}

.pb-4 {
  padding-bottom: 1.5rem !important;
}

.pb-5 {
  padding-bottom: 3rem !important;
}

.ps-0 {
  padding-left: 0 !important;
}

.ps-1 {
  padding-left: 0.25rem !important;
}

.ps-2 {
  padding-left: 0.5rem !important;
}

.ps-3 {
  padding-left: 1rem !important;
}

.ps-4 {
  padding-left: 1.5rem !important;
}

.ps-5 {
  padding-left: 3rem !important;
}

.gap-0 {
  gap: 0 !important;
}

.gap-1 {
  gap: 0.25rem !important;
}

.gap-2 {
  gap: 0.5rem !important;
}

.gap-3 {
  gap: 1rem !important;
}

.gap-4 {
  gap: 1.5rem !important;
}

.gap-5 {
  gap: 3rem !important;
}

.font-monospace {
  font-family: var(--bs-font-monospace) !important;
}

.fs-1 {
  font-size: calc(1.375rem + 1.5vw) !important;
}

.fs-2 {
  font-size: calc(1.325rem + 0.9vw) !important;
}

.fs-3 {
  font-size: calc(1.3rem + 0.6vw) !important;
}

.fs-4 {
  font-size: calc(1.275rem + 0.3vw) !important;
}

.fs-5 {
  font-size: 1.25rem !important;
}

.fs-6 {
  font-size: 1rem !important;
}

.fst-italic {
  font-style: italic !important;
}

.fst-normal {
  font-style: normal !important;
}

.fw-light {
  font-weight: 300 !important;
}

.fw-lighter {
  font-weight: lighter !important;
}

.fw-normal {
  font-weight: 400 !important;
}

.fw-bold {
  font-weight: 700 !important;
}

.fw-semibold {
  font-weight: 600 !important;
}

.fw-bolder {
  font-weight: bolder !important;
}

.lh-1 {
  line-height: 1 !important;
}

.lh-sm {
  line-height: 1.25 !important;
}

.lh-base {
  line-height: 1.5 !important;
}

.lh-lg {
  line-height: 2 !important;
}

.text-start {
  text-align: left !important;
}

.text-end {
  text-align: right !important;
}

.text-center {
  text-align: center !important;
}

.text-decoration-none {
  text-decoration: none !important;
}

.text-decoration-underline {
  text-decoration: underline !important;
}

.text-decoration-line-through {
  text-decoration: line-through !important;
}

.text-lowercase {
  text-transform: lowercase !important;
}

.text-uppercase {
  text-transform: uppercase !important;
}

.text-capitalize {
  text-transform: capitalize !important;
}

.text-wrap {
  white-space: normal !important;
}

.text-nowrap {
  white-space: nowrap !important;
}

/* rtl:begin:remove */
.text-break {
  word-wrap: break-word !important;
  word-break: break-word !important;
}

/* rtl:end:remove */
.text-primary {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-primary-rgb), var(--bs-text-opacity)) !important;
}

.text-secondary {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-secondary-rgb), var(--bs-text-opacity)) !important;
}

.text-success {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-success-rgb), var(--bs-text-opacity)) !important;
}

.text-info {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-info-rgb), var(--bs-text-opacity)) !important;
}

.text-warning {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-warning-rgb), var(--bs-text-opacity)) !important;
}

.text-danger {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-danger-rgb), var(--bs-text-opacity)) !important;
}

.text-light {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-light-rgb), var(--bs-text-opacity)) !important;
}

.text-dark {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-dark-rgb), var(--bs-text-opacity)) !important;
}

.text-black {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-black-rgb), var(--bs-text-opacity)) !important;
}

.text-white {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-white-rgb), var(--bs-text-opacity)) !important;
}

.text-body {
  --bs-text-opacity: 1;
  color: rgba(var(--bs-body-color-rgb), var(--bs-text-opacity)) !important;
}

.text-muted {
  --bs-text-opacity: 1;
  color: #6c757d !important;
}

.text-black-50 {
  --bs-text-opacity: 1;
  color: rgba(0, 0, 0, 0.5) !important;
}

.text-white-50 {
  --bs-text-opacity: 1;
  color: rgba(255, 255, 255, 0.5) !important;
}

.text-reset {
  --bs-text-opacity: 1;
  color: inherit !important;
}

.text-opacity-25 {
  --bs-text-opacity: 0.25;
}

.text-opacity-50 {
  --bs-text-opacity: 0.5;
}

.text-opacity-75 {
  --bs-text-opacity: 0.75;
}

.text-opacity-100 {
  --bs-text-opacity: 1;
}

.bg-primary {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-primary-rgb), var(--bs-bg-opacity)) !important;
}

.bg-secondary {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-secondary-rgb), var(--bs-bg-opacity)) !important;
}

.bg-success {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-success-rgb), var(--bs-bg-opacity)) !important;
}

.bg-info {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-info-rgb), var(--bs-bg-opacity)) !important;
}

.bg-warning {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-warning-rgb), var(--bs-bg-opacity)) !important;
}

.bg-danger {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-danger-rgb), var(--bs-bg-opacity)) !important;
}

.bg-light {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-light-rgb), var(--bs-bg-opacity)) !important;
}

.bg-dark {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-dark-rgb), var(--bs-bg-opacity)) !important;
}

.bg-black {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-black-rgb), var(--bs-bg-opacity)) !important;
}

.bg-white {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-white-rgb), var(--bs-bg-opacity)) !important;
}

.bg-body {
  --bs-bg-opacity: 1;
  background-color: rgba(var(--bs-body-bg-rgb), var(--bs-bg-opacity)) !important;
}

.bg-transparent {
  --bs-bg-opacity: 1;
  background-color: transparent !important;
}

.bg-opacity-10 {
  --bs-bg-opacity: 0.1;
}

.bg-opacity-25 {
  --bs-bg-opacity: 0.25;
}

.bg-opacity-50 {
  --bs-bg-opacity: 0.5;
}

.bg-opacity-75 {
  --bs-bg-opacity: 0.75;
}

.bg-opacity-100 {
  --bs-bg-opacity: 1;
}

.bg-gradient {
  background-image: var(--bs-gradient) !important;
}

.user-select-all {
  -webkit-user-select: all !important;
  -moz-user-select: all !important;
  user-select: all !important;
}

.user-select-auto {
  -webkit-user-select: auto !important;
  -moz-user-select: auto !important;
  user-select: auto !important;
}

.user-select-none {
  -webkit-user-select: none !important;
  -moz-user-select: none !important;
  user-select: none !important;
}

.pe-none {
  pointer-events: none !important;
}

.pe-auto {
  pointer-events: auto !important;
}

.rounded {
  border-radius: var(--bs-border-radius) !important;
}

.rounded-0 {
  border-radius: 0 !important;
}

.rounded-1 {
  border-radius: var(--bs-border-radius-sm) !important;
}

.rounded-2 {
  border-radius: var(--bs-border-radius) !important;
}

.rounded-3 {
  border-radius: var(--bs-border-radius-lg) !important;
}

.rounded-4 {
  border-radius: var(--bs-border-radius-xl) !important;
}

.rounded-5 {
  border-radius: var(--bs-border-radius-2xl) !important;
}

.rounded-circle {
  border-radius: 50% !important;
}

.rounded-pill {
  border-radius: var(--bs-border-radius-pill) !important;
}

.rounded-top {
  border-top-left-radius: var(--bs-border-radius) !important;
  border-top-right-radius: var(--bs-border-radius) !important;
}

.rounded-end {
  border-top-right-radius: var(--bs-border-radius) !important;
  border-bottom-right-radius: var(--bs-border-radius) !important;
}

.rounded-bottom {
  border-bottom-right-radius: var(--bs-border-radius) !important;
  border-bottom-left-radius: var(--bs-border-radius) !important;
}

.rounded-start {
  border-bottom-left-radius: var(--bs-border-radius) !important;
  border-top-left-radius: var(--bs-border-radius) !important;
}

.visible {
  visibility: visible !important;
}

.invisible {
  visibility: hidden !important;
}

@media (min-width: 576px) {
  .float-sm-start {
    float: left !important;
  }
  .float-sm-end {
    float: right !important;
  }
  .float-sm-none {
    float: none !important;
  }
  .d-sm-inline {
    display: inline !important;
  }
  .d-sm-inline-block {
    display: inline-block !important;
  }
  .d-sm-block {
    display: block !important;
  }
  .d-sm-grid {
    display: grid !important;
  }
  .d-sm-table {
    display: table !important;
  }
  .d-sm-table-row {
    display: table-row !important;
  }
  .d-sm-table-cell {
    display: table-cell !important;
  }
  .d-sm-flex {
    display: flex !important;
  }
  .d-sm-inline-flex {
    display: inline-flex !important;
  }
  .d-sm-none {
    display: none !important;
  }
  .flex-sm-fill {
    flex: 1 1 auto !important;
  }
  .flex-sm-row {
    flex-direction: row !important;
  }
  .flex-sm-column {
    flex-direction: column !important;
  }
  .flex-sm-row-reverse {
    flex-direction: row-reverse !important;
  }
  .flex-sm-column-reverse {
    flex-direction: column-reverse !important;
  }
  .flex-sm-grow-0 {
    flex-grow: 0 !important;
  }
  .flex-sm-grow-1 {
    flex-grow: 1 !important;
  }
  .flex-sm-shrink-0 {
    flex-shrink: 0 !important;
  }
  .flex-sm-shrink-1 {
    flex-shrink: 1 !important;
  }
  .flex-sm-wrap {
    flex-wrap: wrap !important;
  }
  .flex-sm-nowrap {
    flex-wrap: nowrap !important;
  }
  .flex-sm-wrap-reverse {
    flex-wrap: wrap-reverse !important;
  }
  .justify-content-sm-start {
    justify-content: flex-start !important;
  }
  .justify-content-sm-end {
    justify-content: flex-end !important;
  }
  .justify-content-sm-center {
    justify-content: center !important;
  }
  .justify-content-sm-between {
    justify-content: space-between !important;
  }
  .justify-content-sm-around {
    justify-content: space-around !important;
  }
  .justify-content-sm-evenly {
    justify-content: space-evenly !important;
  }
  .align-items-sm-start {
    align-items: flex-start !important;
  }
  .align-items-sm-end {
    align-items: flex-end !important;
  }
  .align-items-sm-center {
    align-items: center !important;
  }
  .align-items-sm-baseline {
    align-items: baseline !important;
  }
  .align-items-sm-stretch {
    align-items: stretch !important;
  }
  .align-content-sm-start {
    align-content: flex-start !important;
  }
  .align-content-sm-end {
    align-content: flex-end !important;
  }
  .align-content-sm-center {
    align-content: center !important;
  }
  .align-content-sm-between {
    align-content: space-between !important;
  }
  .align-content-sm-around {
    align-content: space-around !important;
  }
  .align-content-sm-stretch {
    align-content: stretch !important;
  }
  .align-self-sm-auto {
    align-self: auto !important;
  }
  .align-self-sm-start {
    align-self: flex-start !important;
  }
  .align-self-sm-end {
    align-self: flex-end !important;
  }
  .align-self-sm-center {
    align-self: center !important;
  }
  .align-self-sm-baseline {
    align-self: baseline !important;
  }
  .align-self-sm-stretch {
    align-self: stretch !important;
  }
  .order-sm-first {
    order: -1 !important;
  }
  .order-sm-0 {
    order: 0 !important;
  }
  .order-sm-1 {
    order: 1 !important;
  }
  .order-sm-2 {
    order: 2 !important;
  }
  .order-sm-3 {
    order: 3 !important;
  }
  .order-sm-4 {
    order: 4 !important;
  }
  .order-sm-5 {
    order: 5 !important;
  }
  .order-sm-last {
    order: 6 !important;
  }
  .m-sm-0 {
    margin: 0 !important;
  }
  .m-sm-1 {
    margin: 0.25rem !important;
  }
  .m-sm-2 {
    margin: 0.5rem !important;
  }
  .m-sm-3 {
    margin: 1rem !important;
  }
  .m-sm-4 {
    margin: 1.5rem !important;
  }
  .m-sm-5 {
    margin: 3rem !important;
  }
  .m-sm-auto {
    margin: auto !important;
  }
  .mx-sm-0 {
    margin-right: 0 !important;
    margin-left: 0 !important;
  }
  .mx-sm-1 {
    margin-right: 0.25rem !important;
    margin-left: 0.25rem !important;
  }
  .mx-sm-2 {
    margin-right: 0.5rem !important;
    margin-left: 0.5rem !important;
  }
  .mx-sm-3 {
    margin-right: 1rem !important;
    margin-left: 1rem !important;
  }
  .mx-sm-4 {
    margin-right: 1.5rem !important;
    margin-left: 1.5rem !important;
  }
  .mx-sm-5 {
    margin-right: 3rem !important;
    margin-left: 3rem !important;
  }
  .mx-sm-auto {
    margin-right: auto !important;
    margin-left: auto !important;
  }
  .my-sm-0 {
    margin-top: 0 !important;
    margin-bottom: 0 !important;
  }
  .my-sm-1 {
    margin-top: 0.25rem !important;
    margin-bottom: 0.25rem !important;
  }
  .my-sm-2 {
    margin-top: 0.5rem !important;
    margin-bottom: 0.5rem !important;
  }
  .my-sm-3 {
    margin-top: 1rem !important;
    margin-bottom: 1rem !important;
  }
  .my-sm-4 {
    margin-top: 1.5rem !important;
    margin-bottom: 1.5rem !important;
  }
  .my-sm-5 {
    margin-top: 3rem !important;
    margin-bottom: 3rem !important;
  }
  .my-sm-auto {
    margin-top: auto !important;
    margin-bottom: auto !important;
  }
  .mt-sm-0 {
    margin-top: 0 !important;
  }
  .mt-sm-1 {
    margin-top: 0.25rem !important;
  }
  .mt-sm-2 {
    margin-top: 0.5rem !important;
  }
  .mt-sm-3 {
    margin-top: 1rem !important;
  }
  .mt-sm-4 {
    margin-top: 1.5rem !important;
  }
  .mt-sm-5 {
    margin-top: 3rem !important;
  }
  .mt-sm-auto {
    margin-top: auto !important;
  }
  .me-sm-0 {
    margin-right: 0 !important;
  }
  .me-sm-1 {
    margin-right: 0.25rem !important;
  }
  .me-sm-2 {
    margin-right: 0.5rem !important;
  }
  .me-sm-3 {
    margin-right: 1rem !important;
  }
  .me-sm-4 {
    margin-right: 1.5rem !important;
  }
  .me-sm-5 {
    margin-right: 3rem !important;
  }
  .me-sm-auto {
    margin-right: auto !important;
  }
  .mb-sm-0 {
    margin-bottom: 0 !important;
  }
  .mb-sm-1 {
    margin-bottom: 0.25rem !important;
  }
  .mb-sm-2 {
    margin-bottom: 0.5rem !important;
  }
  .mb-sm-3 {
    margin-bottom: 1rem !important;
  }
  .mb-sm-4 {
    margin-bottom: 1.5rem !important;
  }
  .mb-sm-5 {
    margin-bottom: 3rem !important;
  }
  .mb-sm-auto {
    margin-bottom: auto !important;
  }
  .ms-sm-0 {
    margin-left: 0 !important;
  }
  .ms-sm-1 {
    margin-left: 0.25rem !important;
  }
  .ms-sm-2 {
    margin-left: 0.5rem !important;
  }
  .ms-sm-3 {
    margin-left: 1rem !important;
  }
  .ms-sm-4 {
    margin-left: 1.5rem !important;
  }
  .ms-sm-5 {
    margin-left: 3rem !important;
  }
  .ms-sm-auto {
    margin-left: auto !important;
  }
  .p-sm-0 {
    padding: 0 !important;
  }
  .p-sm-1 {
    padding: 0.25rem !important;
  }
  .p-sm-2 {
    padding: 0.5rem !important;
  }
  .p-sm-3 {
    padding: 1rem !important;
  }
  .p-sm-4 {
    padding: 1.5rem !important;
  }
  .p-sm-5 {
    padding: 3rem !important;
  }
  .px-sm-0 {
    padding-right: 0 !important;
    padding-left: 0 !important;
  }
  .px-sm-1 {
    padding-right: 0.25rem !important;
    padding-left: 0.25rem !important;
  }
  .px-sm-2 {
    padding-right: 0.5rem !important;
    padding-left: 0.5rem !important;
  }
  .px-sm-3 {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
  }
  .px-sm-4 {
    padding-right: 1.5rem !important;
    padding-left: 1.5rem !important;
  }
  .px-sm-5 {
    padding-right: 3rem !important;
    padding-left: 3rem !important;
  }
  .py-sm-0 {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
  }
  .py-sm-1 {
    padding-top: 0.25rem !important;
    padding-bottom: 0.25rem !important;
  }
  .py-sm-2 {
    padding-top: 0.5rem !important;
    padding-bottom: 0.5rem !important;
  }
  .py-sm-3 {
    padding-top: 1rem !important;
    padding-bottom: 1rem !important;
  }
  .py-sm-4 {
    padding-top: 1.5rem !important;
    padding-bottom: 1.5rem !important;
  }
  .py-sm-5 {
    padding-top: 3rem !important;
    padding-bottom: 3rem !important;
  }
  .pt-sm-0 {
    padding-top: 0 !important;
  }
  .pt-sm-1 {
    padding-top: 0.25rem !important;
  }
  .pt-sm-2 {
    padding-top: 0.5rem !important;
  }
  .pt-sm-3 {
    padding-top: 1rem !important;
  }
  .pt-sm-4 {
    padding-top: 1.5rem !important;
  }
  .pt-sm-5 {
    padding-top: 3rem !important;
  }
  .pe-sm-0 {
    padding-right: 0 !important;
  }
  .pe-sm-1 {
    padding-right: 0.25rem !important;
  }
  .pe-sm-2 {
    padding-right: 0.5rem !important;
  }
  .pe-sm-3 {
    padding-right: 1rem !important;
  }
  .pe-sm-4 {
    padding-right: 1.5rem !important;
  }
  .pe-sm-5 {
    padding-right: 3rem !important;
  }
  .pb-sm-0 {
    padding-bottom: 0 !important;
  }
  .pb-sm-1 {
    padding-bottom: 0.25rem !important;
  }
  .pb-sm-2 {
    padding-bottom: 0.5rem !important;
  }
  .pb-sm-3 {
    padding-bottom: 1rem !important;
  }
  .pb-sm-4 {
    padding-bottom: 1.5rem !important;
  }
  .pb-sm-5 {
    padding-bottom: 3rem !important;
  }
  .ps-sm-0 {
    padding-left: 0 !important;
  }
  .ps-sm-1 {
    padding-left: 0.25rem !important;
  }
  .ps-sm-2 {
    padding-left: 0.5rem !important;
  }
  .ps-sm-3 {
    padding-left: 1rem !important;
  }
  .ps-sm-4 {
    padding-left: 1.5rem !important;
  }
  .ps-sm-5 {
    padding-left: 3rem !important;
  }
  .gap-sm-0 {
    gap: 0 !important;
  }
  .gap-sm-1 {
    gap: 0.25rem !important;
  }
  .gap-sm-2 {
    gap: 0.5rem !important;
  }
  .gap-sm-3 {
    gap: 1rem !important;
  }
  .gap-sm-4 {
    gap: 1.5rem !important;
  }
  .gap-sm-5 {
    gap: 3rem !important;
  }
  .text-sm-start {
    text-align: left !important;
  }
  .text-sm-end {
    text-align: right !important;
  }
  .text-sm-center {
    text-align: center !important;
  }
}
@media (min-width: 768px) {
  .float-md-start {
    float: left !important;
  }
  .float-md-end {
    float: right !important;
  }
  .float-md-none {
    float: none !important;
  }
  .d-md-inline {
    display: inline !important;
  }
  .d-md-inline-block {
    display: inline-block !important;
  }
  .d-md-block {
    display: block !important;
  }
  .d-md-grid {
    display: grid !important;
  }
  .d-md-table {
    display: table !important;
  }
  .d-md-table-row {
    display: table-row !important;
  }
  .d-md-table-cell {
    display: table-cell !important;
  }
  .d-md-flex {
    display: flex !important;
  }
  .d-md-inline-flex {
    display: inline-flex !important;
  }
  .d-md-none {
    display: none !important;
  }
  .flex-md-fill {
    flex: 1 1 auto !important;
  }
  .flex-md-row {
    flex-direction: row !important;
  }
  .flex-md-column {
    flex-direction: column !important;
  }
  .flex-md-row-reverse {
    flex-direction: row-reverse !important;
  }
  .flex-md-column-reverse {
    flex-direction: column-reverse !important;
  }
  .flex-md-grow-0 {
    flex-grow: 0 !important;
  }
  .flex-md-grow-1 {
    flex-grow: 1 !important;
  }
  .flex-md-shrink-0 {
    flex-shrink: 0 !important;
  }
  .flex-md-shrink-1 {
    flex-shrink: 1 !important;
  }
  .flex-md-wrap {
    flex-wrap: wrap !important;
  }
  .flex-md-nowrap {
    flex-wrap: nowrap !important;
  }
  .flex-md-wrap-reverse {
    flex-wrap: wrap-reverse !important;
  }
  .justify-content-md-start {
    justify-content: flex-start !important;
  }
  .justify-content-md-end {
    justify-content: flex-end !important;
  }
  .justify-content-md-center {
    justify-content: center !important;
  }
  .justify-content-md-between {
    justify-content: space-between !important;
  }
  .justify-content-md-around {
    justify-content: space-around !important;
  }
  .justify-content-md-evenly {
    justify-content: space-evenly !important;
  }
  .align-items-md-start {
    align-items: flex-start !important;
  }
  .align-items-md-end {
    align-items: flex-end !important;
  }
  .align-items-md-center {
    align-items: center !important;
  }
  .align-items-md-baseline {
    align-items: baseline !important;
  }
  .align-items-md-stretch {
    align-items: stretch !important;
  }
  .align-content-md-start {
    align-content: flex-start !important;
  }
  .align-content-md-end {
    align-content: flex-end !important;
  }
  .align-content-md-center {
    align-content: center !important;
  }
  .align-content-md-between {
    align-content: space-between !important;
  }
  .align-content-md-around {
    align-content: space-around !important;
  }
  .align-content-md-stretch {
    align-content: stretch !important;
  }
  .align-self-md-auto {
    align-self: auto !important;
  }
  .align-self-md-start {
    align-self: flex-start !important;
  }
  .align-self-md-end {
    align-self: flex-end !important;
  }
  .align-self-md-center {
    align-self: center !important;
  }
  .align-self-md-baseline {
    align-self: baseline !important;
  }
  .align-self-md-stretch {
    align-self: stretch !important;
  }
  .order-md-first {
    order: -1 !important;
  }
  .order-md-0 {
    order: 0 !important;
  }
  .order-md-1 {
    order: 1 !important;
  }
  .order-md-2 {
    order: 2 !important;
  }
  .order-md-3 {
    order: 3 !important;
  }
  .order-md-4 {
    order: 4 !important;
  }
  .order-md-5 {
    order: 5 !important;
  }
  .order-md-last {
    order: 6 !important;
  }
  .m-md-0 {
    margin: 0 !important;
  }
  .m-md-1 {
    margin: 0.25rem !important;
  }
  .m-md-2 {
    margin: 0.5rem !important;
  }
  .m-md-3 {
    margin: 1rem !important;
  }
  .m-md-4 {
    margin: 1.5rem !important;
  }
  .m-md-5 {
    margin: 3rem !important;
  }
  .m-md-auto {
    margin: auto !important;
  }
  .mx-md-0 {
    margin-right: 0 !important;
    margin-left: 0 !important;
  }
  .mx-md-1 {
    margin-right: 0.25rem !important;
    margin-left: 0.25rem !important;
  }
  .mx-md-2 {
    margin-right: 0.5rem !important;
    margin-left: 0.5rem !important;
  }
  .mx-md-3 {
    margin-right: 1rem !important;
    margin-left: 1rem !important;
  }
  .mx-md-4 {
    margin-right: 1.5rem !important;
    margin-left: 1.5rem !important;
  }
  .mx-md-5 {
    margin-right: 3rem !important;
    margin-left: 3rem !important;
  }
  .mx-md-auto {
    margin-right: auto !important;
    margin-left: auto !important;
  }
  .my-md-0 {
    margin-top: 0 !important;
    margin-bottom: 0 !important;
  }
  .my-md-1 {
    margin-top: 0.25rem !important;
    margin-bottom: 0.25rem !important;
  }
  .my-md-2 {
    margin-top: 0.5rem !important;
    margin-bottom: 0.5rem !important;
  }
  .my-md-3 {
    margin-top: 1rem !important;
    margin-bottom: 1rem !important;
  }
  .my-md-4 {
    margin-top: 1.5rem !important;
    margin-bottom: 1.5rem !important;
  }
  .my-md-5 {
    margin-top: 3rem !important;
    margin-bottom: 3rem !important;
  }
  .my-md-auto {
    margin-top: auto !important;
    margin-bottom: auto !important;
  }
  .mt-md-0 {
    margin-top: 0 !important;
  }
  .mt-md-1 {
    margin-top: 0.25rem !important;
  }
  .mt-md-2 {
    margin-top: 0.5rem !important;
  }
  .mt-md-3 {
    margin-top: 1rem !important;
  }
  .mt-md-4 {
    margin-top: 1.5rem !important;
  }
  .mt-md-5 {
    margin-top: 3rem !important;
  }
  .mt-md-auto {
    margin-top: auto !important;
  }
  .me-md-0 {
    margin-right: 0 !important;
  }
  .me-md-1 {
    margin-right: 0.25rem !important;
  }
  .me-md-2 {
    margin-right: 0.5rem !important;
  }
  .me-md-3 {
    margin-right: 1rem !important;
  }
  .me-md-4 {
    margin-right: 1.5rem !important;
  }
  .me-md-5 {
    margin-right: 3rem !important;
  }
  .me-md-auto {
    margin-right: auto !important;
  }
  .mb-md-0 {
    margin-bottom: 0 !important;
  }
  .mb-md-1 {
    margin-bottom: 0.25rem !important;
  }
  .mb-md-2 {
    margin-bottom: 0.5rem !important;
  }
  .mb-md-3 {
    margin-bottom: 1rem !important;
  }
  .mb-md-4 {
    margin-bottom: 1.5rem !important;
  }
  .mb-md-5 {
    margin-bottom: 3rem !important;
  }
  .mb-md-auto {
    margin-bottom: auto !important;
  }
  .ms-md-0 {
    margin-left: 0 !important;
  }
  .ms-md-1 {
    margin-left: 0.25rem !important;
  }
  .ms-md-2 {
    margin-left: 0.5rem !important;
  }
  .ms-md-3 {
    margin-left: 1rem !important;
  }
  .ms-md-4 {
    margin-left: 1.5rem !important;
  }
  .ms-md-5 {
    margin-left: 3rem !important;
  }
  .ms-md-auto {
    margin-left: auto !important;
  }
  .p-md-0 {
    padding: 0 !important;
  }
  .p-md-1 {
    padding: 0.25rem !important;
  }
  .p-md-2 {
    padding: 0.5rem !important;
  }
  .p-md-3 {
    padding: 1rem !important;
  }
  .p-md-4 {
    padding: 1.5rem !important;
  }
  .p-md-5 {
    padding: 3rem !important;
  }
  .px-md-0 {
    padding-right: 0 !important;
    padding-left: 0 !important;
  }
  .px-md-1 {
    padding-right: 0.25rem !important;
    padding-left: 0.25rem !important;
  }
  .px-md-2 {
    padding-right: 0.5rem !important;
    padding-left: 0.5rem !important;
  }
  .px-md-3 {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
  }
  .px-md-4 {
    padding-right: 1.5rem !important;
    padding-left: 1.5rem !important;
  }
  .px-md-5 {
    padding-right: 3rem !important;
    padding-left: 3rem !important;
  }
  .py-md-0 {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
  }
  .py-md-1 {
    padding-top: 0.25rem !important;
    padding-bottom: 0.25rem !important;
  }
  .py-md-2 {
    padding-top: 0.5rem !important;
    padding-bottom: 0.5rem !important;
  }
  .py-md-3 {
    padding-top: 1rem !important;
    padding-bottom: 1rem !important;
  }
  .py-md-4 {
    padding-top: 1.5rem !important;
    padding-bottom: 1.5rem !important;
  }
  .py-md-5 {
    padding-top: 3rem !important;
    padding-bottom: 3rem !important;
  }
  .pt-md-0 {
    padding-top: 0 !important;
  }
  .pt-md-1 {
    padding-top: 0.25rem !important;
  }
  .pt-md-2 {
    padding-top: 0.5rem !important;
  }
  .pt-md-3 {
    padding-top: 1rem !important;
  }
  .pt-md-4 {
    padding-top: 1.5rem !important;
  }
  .pt-md-5 {
    padding-top: 3rem !important;
  }
  .pe-md-0 {
    padding-right: 0 !important;
  }
  .pe-md-1 {
    padding-right: 0.25rem !important;
  }
  .pe-md-2 {
    padding-right: 0.5rem !important;
  }
  .pe-md-3 {
    padding-right: 1rem !important;
  }
  .pe-md-4 {
    padding-right: 1.5rem !important;
  }
  .pe-md-5 {
    padding-right: 3rem !important;
  }
  .pb-md-0 {
    padding-bottom: 0 !important;
  }
  .pb-md-1 {
    padding-bottom: 0.25rem !important;
  }
  .pb-md-2 {
    padding-bottom: 0.5rem !important;
  }
  .pb-md-3 {
    padding-bottom: 1rem !important;
  }
  .pb-md-4 {
    padding-bottom: 1.5rem !important;
  }
  .pb-md-5 {
    padding-bottom: 3rem !important;
  }
  .ps-md-0 {
    padding-left: 0 !important;
  }
  .ps-md-1 {
    padding-left: 0.25rem !important;
  }
  .ps-md-2 {
    padding-left: 0.5rem !important;
  }
  .ps-md-3 {
    padding-left: 1rem !important;
  }
  .ps-md-4 {
    padding-left: 1.5rem !important;
  }
  .ps-md-5 {
    padding-left: 3rem !important;
  }
  .gap-md-0 {
    gap: 0 !important;
  }
  .gap-md-1 {
    gap: 0.25rem !important;
  }
  .gap-md-2 {
    gap: 0.5rem !important;
  }
  .gap-md-3 {
    gap: 1rem !important;
  }
  .gap-md-4 {
    gap: 1.5rem !important;
  }
  .gap-md-5 {
    gap: 3rem !important;
  }
  .text-md-start {
    text-align: left !important;
  }
  .text-md-end {
    text-align: right !important;
  }
  .text-md-center {
    text-align: center !important;
  }
}
@media (min-width: 992px) {
  .float-lg-start {
    float: left !important;
  }
  .float-lg-end {
    float: right !important;
  }
  .float-lg-none {
    float: none !important;
  }
  .d-lg-inline {
    display: inline !important;
  }
  .d-lg-inline-block {
    display: inline-block !important;
  }
  .d-lg-block {
    display: block !important;
  }
  .d-lg-grid {
    display: grid !important;
  }
  .d-lg-table {
    display: table !important;
  }
  .d-lg-table-row {
    display: table-row !important;
  }
  .d-lg-table-cell {
    display: table-cell !important;
  }
  .d-lg-flex {
    display: flex !important;
  }
  .d-lg-inline-flex {
    display: inline-flex !important;
  }
  .d-lg-none {
    display: none !important;
  }
  .flex-lg-fill {
    flex: 1 1 auto !important;
  }
  .flex-lg-row {
    flex-direction: row !important;
  }
  .flex-lg-column {
    flex-direction: column !important;
  }
  .flex-lg-row-reverse {
    flex-direction: row-reverse !important;
  }
  .flex-lg-column-reverse {
    flex-direction: column-reverse !important;
  }
  .flex-lg-grow-0 {
    flex-grow: 0 !important;
  }
  .flex-lg-grow-1 {
    flex-grow: 1 !important;
  }
  .flex-lg-shrink-0 {
    flex-shrink: 0 !important;
  }
  .flex-lg-shrink-1 {
    flex-shrink: 1 !important;
  }
  .flex-lg-wrap {
    flex-wrap: wrap !important;
  }
  .flex-lg-nowrap {
    flex-wrap: nowrap !important;
  }
  .flex-lg-wrap-reverse {
    flex-wrap: wrap-reverse !important;
  }
  .justify-content-lg-start {
    justify-content: flex-start !important;
  }
  .justify-content-lg-end {
    justify-content: flex-end !important;
  }
  .justify-content-lg-center {
    justify-content: center !important;
  }
  .justify-content-lg-between {
    justify-content: space-between !important;
  }
  .justify-content-lg-around {
    justify-content: space-around !important;
  }
  .justify-content-lg-evenly {
    justify-content: space-evenly !important;
  }
  .align-items-lg-start {
    align-items: flex-start !important;
  }
  .align-items-lg-end {
    align-items: flex-end !important;
  }
  .align-items-lg-center {
    align-items: center !important;
  }
  .align-items-lg-baseline {
    align-items: baseline !important;
  }
  .align-items-lg-stretch {
    align-items: stretch !important;
  }
  .align-content-lg-start {
    align-content: flex-start !important;
  }
  .align-content-lg-end {
    align-content: flex-end !important;
  }
  .align-content-lg-center {
    align-content: center !important;
  }
  .align-content-lg-between {
    align-content: space-between !important;
  }
  .align-content-lg-around {
    align-content: space-around !important;
  }
  .align-content-lg-stretch {
    align-content: stretch !important;
  }
  .align-self-lg-auto {
    align-self: auto !important;
  }
  .align-self-lg-start {
    align-self: flex-start !important;
  }
  .align-self-lg-end {
    align-self: flex-end !important;
  }
  .align-self-lg-center {
    align-self: center !important;
  }
  .align-self-lg-baseline {
    align-self: baseline !important;
  }
  .align-self-lg-stretch {
    align-self: stretch !important;
  }
  .order-lg-first {
    order: -1 !important;
  }
  .order-lg-0 {
    order: 0 !important;
  }
  .order-lg-1 {
    order: 1 !important;
  }
  .order-lg-2 {
    order: 2 !important;
  }
  .order-lg-3 {
    order: 3 !important;
  }
  .order-lg-4 {
    order: 4 !important;
  }
  .order-lg-5 {
    order: 5 !important;
  }
  .order-lg-last {
    order: 6 !important;
  }
  .m-lg-0 {
    margin: 0 !important;
  }
  .m-lg-1 {
    margin: 0.25rem !important;
  }
  .m-lg-2 {
    margin: 0.5rem !important;
  }
  .m-lg-3 {
    margin: 1rem !important;
  }
  .m-lg-4 {
    margin: 1.5rem !important;
  }
  .m-lg-5 {
    margin: 3rem !important;
  }
  .m-lg-auto {
    margin: auto !important;
  }
  .mx-lg-0 {
    margin-right: 0 !important;
    margin-left: 0 !important;
  }
  .mx-lg-1 {
    margin-right: 0.25rem !important;
    margin-left: 0.25rem !important;
  }
  .mx-lg-2 {
    margin-right: 0.5rem !important;
    margin-left: 0.5rem !important;
  }
  .mx-lg-3 {
    margin-right: 1rem !important;
    margin-left: 1rem !important;
  }
  .mx-lg-4 {
    margin-right: 1.5rem !important;
    margin-left: 1.5rem !important;
  }
  .mx-lg-5 {
    margin-right: 3rem !important;
    margin-left: 3rem !important;
  }
  .mx-lg-auto {
    margin-right: auto !important;
    margin-left: auto !important;
  }
  .my-lg-0 {
    margin-top: 0 !important;
    margin-bottom: 0 !important;
  }
  .my-lg-1 {
    margin-top: 0.25rem !important;
    margin-bottom: 0.25rem !important;
  }
  .my-lg-2 {
    margin-top: 0.5rem !important;
    margin-bottom: 0.5rem !important;
  }
  .my-lg-3 {
    margin-top: 1rem !important;
    margin-bottom: 1rem !important;
  }
  .my-lg-4 {
    margin-top: 1.5rem !important;
    margin-bottom: 1.5rem !important;
  }
  .my-lg-5 {
    margin-top: 3rem !important;
    margin-bottom: 3rem !important;
  }
  .my-lg-auto {
    margin-top: auto !important;
    margin-bottom: auto !important;
  }
  .mt-lg-0 {
    margin-top: 0 !important;
  }
  .mt-lg-1 {
    margin-top: 0.25rem !important;
  }
  .mt-lg-2 {
    margin-top: 0.5rem !important;
  }
  .mt-lg-3 {
    margin-top: 1rem !important;
  }
  .mt-lg-4 {
    margin-top: 1.5rem !important;
  }
  .mt-lg-5 {
    margin-top: 3rem !important;
  }
  .mt-lg-auto {
    margin-top: auto !important;
  }
  .me-lg-0 {
    margin-right: 0 !important;
  }
  .me-lg-1 {
    margin-right: 0.25rem !important;
  }
  .me-lg-2 {
    margin-right: 0.5rem !important;
  }
  .me-lg-3 {
    margin-right: 1rem !important;
  }
  .me-lg-4 {
    margin-right: 1.5rem !important;
  }
  .me-lg-5 {
    margin-right: 3rem !important;
  }
  .me-lg-auto {
    margin-right: auto !important;
  }
  .mb-lg-0 {
    margin-bottom: 0 !important;
  }
  .mb-lg-1 {
    margin-bottom: 0.25rem !important;
  }
  .mb-lg-2 {
    margin-bottom: 0.5rem !important;
  }
  .mb-lg-3 {
    margin-bottom: 1rem !important;
  }
  .mb-lg-4 {
    margin-bottom: 1.5rem !important;
  }
  .mb-lg-5 {
    margin-bottom: 3rem !important;
  }
  .mb-lg-auto {
    margin-bottom: auto !important;
  }
  .ms-lg-0 {
    margin-left: 0 !important;
  }
  .ms-lg-1 {
    margin-left: 0.25rem !important;
  }
  .ms-lg-2 {
    margin-left: 0.5rem !important;
  }
  .ms-lg-3 {
    margin-left: 1rem !important;
  }
  .ms-lg-4 {
    margin-left: 1.5rem !important;
  }
  .ms-lg-5 {
    margin-left: 3rem !important;
  }
  .ms-lg-auto {
    margin-left: auto !important;
  }
  .p-lg-0 {
    padding: 0 !important;
  }
  .p-lg-1 {
    padding: 0.25rem !important;
  }
  .p-lg-2 {
    padding: 0.5rem !important;
  }
  .p-lg-3 {
    padding: 1rem !important;
  }
  .p-lg-4 {
    padding: 1.5rem !important;
  }
  .p-lg-5 {
    padding: 3rem !important;
  }
  .px-lg-0 {
    padding-right: 0 !important;
    padding-left: 0 !important;
  }
  .px-lg-1 {
    padding-right: 0.25rem !important;
    padding-left: 0.25rem !important;
  }
  .px-lg-2 {
    padding-right: 0.5rem !important;
    padding-left: 0.5rem !important;
  }
  .px-lg-3 {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
  }
  .px-lg-4 {
    padding-right: 1.5rem !important;
    padding-left: 1.5rem !important;
  }
  .px-lg-5 {
    padding-right: 3rem !important;
    padding-left: 3rem !important;
  }
  .py-lg-0 {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
  }
  .py-lg-1 {
    padding-top: 0.25rem !important;
    padding-bottom: 0.25rem !important;
  }
  .py-lg-2 {
    padding-top: 0.5rem !important;
    padding-bottom: 0.5rem !important;
  }
  .py-lg-3 {
    padding-top: 1rem !important;
    padding-bottom: 1rem !important;
  }
  .py-lg-4 {
    padding-top: 1.5rem !important;
    padding-bottom: 1.5rem !important;
  }
  .py-lg-5 {
    padding-top: 3rem !important;
    padding-bottom: 3rem !important;
  }
  .pt-lg-0 {
    padding-top: 0 !important;
  }
  .pt-lg-1 {
    padding-top: 0.25rem !important;
  }
  .pt-lg-2 {
    padding-top: 0.5rem !important;
  }
  .pt-lg-3 {
    padding-top: 1rem !important;
  }
  .pt-lg-4 {
    padding-top: 1.5rem !important;
  }
  .pt-lg-5 {
    padding-top: 3rem !important;
  }
  .pe-lg-0 {
    padding-right: 0 !important;
  }
  .pe-lg-1 {
    padding-right: 0.25rem !important;
  }
  .pe-lg-2 {
    padding-right: 0.5rem !important;
  }
  .pe-lg-3 {
    padding-right: 1rem !important;
  }
  .pe-lg-4 {
    padding-right: 1.5rem !important;
  }
  .pe-lg-5 {
    padding-right: 3rem !important;
  }
  .pb-lg-0 {
    padding-bottom: 0 !important;
  }
  .pb-lg-1 {
    padding-bottom: 0.25rem !important;
  }
  .pb-lg-2 {
    padding-bottom: 0.5rem !important;
  }
  .pb-lg-3 {
    padding-bottom: 1rem !important;
  }
  .pb-lg-4 {
    padding-bottom: 1.5rem !important;
  }
  .pb-lg-5 {
    padding-bottom: 3rem !important;
  }
  .ps-lg-0 {
    padding-left: 0 !important;
  }
  .ps-lg-1 {
    padding-left: 0.25rem !important;
  }
  .ps-lg-2 {
    padding-left: 0.5rem !important;
  }
  .ps-lg-3 {
    padding-left: 1rem !important;
  }
  .ps-lg-4 {
    padding-left: 1.5rem !important;
  }
  .ps-lg-5 {
    padding-left: 3rem !important;
  }
  .gap-lg-0 {
    gap: 0 !important;
  }
  .gap-lg-1 {
    gap: 0.25rem !important;
  }
  .gap-lg-2 {
    gap: 0.5rem !important;
  }
  .gap-lg-3 {
    gap: 1rem !important;
  }
  .gap-lg-4 {
    gap: 1.5rem !important;
  }
  .gap-lg-5 {
    gap: 3rem !important;
  }
  .text-lg-start {
    text-align: left !important;
  }
  .text-lg-end {
    text-align: right !important;
  }
  .text-lg-center {
    text-align: center !important;
  }
}
@media (min-width: 1200px) {
  .float-xl-start {
    float: left !important;
  }
  .float-xl-end {
    float: right !important;
  }
  .float-xl-none {
    float: none !important;
  }
  .d-xl-inline {
    display: inline !important;
  }
  .d-xl-inline-block {
    display: inline-block !important;
  }
  .d-xl-block {
    display: block !important;
  }
  .d-xl-grid {
    display: grid !important;
  }
  .d-xl-table {
    display: table !important;
  }
  .d-xl-table-row {
    display: table-row !important;
  }
  .d-xl-table-cell {
    display: table-cell !important;
  }
  .d-xl-flex {
    display: flex !important;
  }
  .d-xl-inline-flex {
    display: inline-flex !important;
  }
  .d-xl-none {
    display: none !important;
  }
  .flex-xl-fill {
    flex: 1 1 auto !important;
  }
  .flex-xl-row {
    flex-direction: row !important;
  }
  .flex-xl-column {
    flex-direction: column !important;
  }
  .flex-xl-row-reverse {
    flex-direction: row-reverse !important;
  }
  .flex-xl-column-reverse {
    flex-direction: column-reverse !important;
  }
  .flex-xl-grow-0 {
    flex-grow: 0 !important;
  }
  .flex-xl-grow-1 {
    flex-grow: 1 !important;
  }
  .flex-xl-shrink-0 {
    flex-shrink: 0 !important;
  }
  .flex-xl-shrink-1 {
    flex-shrink: 1 !important;
  }
  .flex-xl-wrap {
    flex-wrap: wrap !important;
  }
  .flex-xl-nowrap {
    flex-wrap: nowrap !important;
  }
  .flex-xl-wrap-reverse {
    flex-wrap: wrap-reverse !important;
  }
  .justify-content-xl-start {
    justify-content: flex-start !important;
  }
  .justify-content-xl-end {
    justify-content: flex-end !important;
  }
  .justify-content-xl-center {
    justify-content: center !important;
  }
  .justify-content-xl-between {
    justify-content: space-between !important;
  }
  .justify-content-xl-around {
    justify-content: space-around !important;
  }
  .justify-content-xl-evenly {
    justify-content: space-evenly !important;
  }
  .align-items-xl-start {
    align-items: flex-start !important;
  }
  .align-items-xl-end {
    align-items: flex-end !important;
  }
  .align-items-xl-center {
    align-items: center !important;
  }
  .align-items-xl-baseline {
    align-items: baseline !important;
  }
  .align-items-xl-stretch {
    align-items: stretch !important;
  }
  .align-content-xl-start {
    align-content: flex-start !important;
  }
  .align-content-xl-end {
    align-content: flex-end !important;
  }
  .align-content-xl-center {
    align-content: center !important;
  }
  .align-content-xl-between {
    align-content: space-between !important;
  }
  .align-content-xl-around {
    align-content: space-around !important;
  }
  .align-content-xl-stretch {
    align-content: stretch !important;
  }
  .align-self-xl-auto {
    align-self: auto !important;
  }
  .align-self-xl-start {
    align-self: flex-start !important;
  }
  .align-self-xl-end {
    align-self: flex-end !important;
  }
  .align-self-xl-center {
    align-self: center !important;
  }
  .align-self-xl-baseline {
    align-self: baseline !important;
  }
  .align-self-xl-stretch {
    align-self: stretch !important;
  }
  .order-xl-first {
    order: -1 !important;
  }
  .order-xl-0 {
    order: 0 !important;
  }
  .order-xl-1 {
    order: 1 !important;
  }
  .order-xl-2 {
    order: 2 !important;
  }
  .order-xl-3 {
    order: 3 !important;
  }
  .order-xl-4 {
    order: 4 !important;
  }
  .order-xl-5 {
    order: 5 !important;
  }
  .order-xl-last {
    order: 6 !important;
  }
  .m-xl-0 {
    margin: 0 !important;
  }
  .m-xl-1 {
    margin: 0.25rem !important;
  }
  .m-xl-2 {
    margin: 0.5rem !important;
  }
  .m-xl-3 {
    margin: 1rem !important;
  }
  .m-xl-4 {
    margin: 1.5rem !important;
  }
  .m-xl-5 {
    margin: 3rem !important;
  }
  .m-xl-auto {
    margin: auto !important;
  }
  .mx-xl-0 {
    margin-right: 0 !important;
    margin-left: 0 !important;
  }
  .mx-xl-1 {
    margin-right: 0.25rem !important;
    margin-left: 0.25rem !important;
  }
  .mx-xl-2 {
    margin-right: 0.5rem !important;
    margin-left: 0.5rem !important;
  }
  .mx-xl-3 {
    margin-right: 1rem !important;
    margin-left: 1rem !important;
  }
  .mx-xl-4 {
    margin-right: 1.5rem !important;
    margin-left: 1.5rem !important;
  }
  .mx-xl-5 {
    margin-right: 3rem !important;
    margin-left: 3rem !important;
  }
  .mx-xl-auto {
    margin-right: auto !important;
    margin-left: auto !important;
  }
  .my-xl-0 {
    margin-top: 0 !important;
    margin-bottom: 0 !important;
  }
  .my-xl-1 {
    margin-top: 0.25rem !important;
    margin-bottom: 0.25rem !important;
  }
  .my-xl-2 {
    margin-top: 0.5rem !important;
    margin-bottom: 0.5rem !important;
  }
  .my-xl-3 {
    margin-top: 1rem !important;
    margin-bottom: 1rem !important;
  }
  .my-xl-4 {
    margin-top: 1.5rem !important;
    margin-bottom: 1.5rem !important;
  }
  .my-xl-5 {
    margin-top: 3rem !important;
    margin-bottom: 3rem !important;
  }
  .my-xl-auto {
    margin-top: auto !important;
    margin-bottom: auto !important;
  }
  .mt-xl-0 {
    margin-top: 0 !important;
  }
  .mt-xl-1 {
    margin-top: 0.25rem !important;
  }
  .mt-xl-2 {
    margin-top: 0.5rem !important;
  }
  .mt-xl-3 {
    margin-top: 1rem !important;
  }
  .mt-xl-4 {
    margin-top: 1.5rem !important;
  }
  .mt-xl-5 {
    margin-top: 3rem !important;
  }
  .mt-xl-auto {
    margin-top: auto !important;
  }
  .me-xl-0 {
    margin-right: 0 !important;
  }
  .me-xl-1 {
    margin-right: 0.25rem !important;
  }
  .me-xl-2 {
    margin-right: 0.5rem !important;
  }
  .me-xl-3 {
    margin-right: 1rem !important;
  }
  .me-xl-4 {
    margin-right: 1.5rem !important;
  }
  .me-xl-5 {
    margin-right: 3rem !important;
  }
  .me-xl-auto {
    margin-right: auto !important;
  }
  .mb-xl-0 {
    margin-bottom: 0 !important;
  }
  .mb-xl-1 {
    margin-bottom: 0.25rem !important;
  }
  .mb-xl-2 {
    margin-bottom: 0.5rem !important;
  }
  .mb-xl-3 {
    margin-bottom: 1rem !important;
  }
  .mb-xl-4 {
    margin-bottom: 1.5rem !important;
  }
  .mb-xl-5 {
    margin-bottom: 3rem !important;
  }
  .mb-xl-auto {
    margin-bottom: auto !important;
  }
  .ms-xl-0 {
    margin-left: 0 !important;
  }
  .ms-xl-1 {
    margin-left: 0.25rem !important;
  }
  .ms-xl-2 {
    margin-left: 0.5rem !important;
  }
  .ms-xl-3 {
    margin-left: 1rem !important;
  }
  .ms-xl-4 {
    margin-left: 1.5rem !important;
  }
  .ms-xl-5 {
    margin-left: 3rem !important;
  }
  .ms-xl-auto {
    margin-left: auto !important;
  }
  .p-xl-0 {
    padding: 0 !important;
  }
  .p-xl-1 {
    padding: 0.25rem !important;
  }
  .p-xl-2 {
    padding: 0.5rem !important;
  }
  .p-xl-3 {
    padding: 1rem !important;
  }
  .p-xl-4 {
    padding: 1.5rem !important;
  }
  .p-xl-5 {
    padding: 3rem !important;
  }
  .px-xl-0 {
    padding-right: 0 !important;
    padding-left: 0 !important;
  }
  .px-xl-1 {
    padding-right: 0.25rem !important;
    padding-left: 0.25rem !important;
  }
  .px-xl-2 {
    padding-right: 0.5rem !important;
    padding-left: 0.5rem !important;
  }
  .px-xl-3 {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
  }
  .px-xl-4 {
    padding-right: 1.5rem !important;
    padding-left: 1.5rem !important;
  }
  .px-xl-5 {
    padding-right: 3rem !important;
    padding-left: 3rem !important;
  }
  .py-xl-0 {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
  }
  .py-xl-1 {
    padding-top: 0.25rem !important;
    padding-bottom: 0.25rem !important;
  }
  .py-xl-2 {
    padding-top: 0.5rem !important;
    padding-bottom: 0.5rem !important;
  }
  .py-xl-3 {
    padding-top: 1rem !important;
    padding-bottom: 1rem !important;
  }
  .py-xl-4 {
    padding-top: 1.5rem !important;
    padding-bottom: 1.5rem !important;
  }
  .py-xl-5 {
    padding-top: 3rem !important;
    padding-bottom: 3rem !important;
  }
  .pt-xl-0 {
    padding-top: 0 !important;
  }
  .pt-xl-1 {
    padding-top: 0.25rem !important;
  }
  .pt-xl-2 {
    padding-top: 0.5rem !important;
  }
  .pt-xl-3 {
    padding-top: 1rem !important;
  }
  .pt-xl-4 {
    padding-top: 1.5rem !important;
  }
  .pt-xl-5 {
    padding-top: 3rem !important;
  }
  .pe-xl-0 {
    padding-right: 0 !important;
  }
  .pe-xl-1 {
    padding-right: 0.25rem !important;
  }
  .pe-xl-2 {
    padding-right: 0.5rem !important;
  }
  .pe-xl-3 {
    padding-right: 1rem !important;
  }
  .pe-xl-4 {
    padding-right: 1.5rem !important;
  }
  .pe-xl-5 {
    padding-right: 3rem !important;
  }
  .pb-xl-0 {
    padding-bottom: 0 !important;
  }
  .pb-xl-1 {
    padding-bottom: 0.25rem !important;
  }
  .pb-xl-2 {
    padding-bottom: 0.5rem !important;
  }
  .pb-xl-3 {
    padding-bottom: 1rem !important;
  }
  .pb-xl-4 {
    padding-bottom: 1.5rem !important;
  }
  .pb-xl-5 {
    padding-bottom: 3rem !important;
  }
  .ps-xl-0 {
    padding-left: 0 !important;
  }
  .ps-xl-1 {
    padding-left: 0.25rem !important;
  }
  .ps-xl-2 {
    padding-left: 0.5rem !important;
  }
  .ps-xl-3 {
    padding-left: 1rem !important;
  }
  .ps-xl-4 {
    padding-left: 1.5rem !important;
  }
  .ps-xl-5 {
    padding-left: 3rem !important;
  }
  .gap-xl-0 {
    gap: 0 !important;
  }
  .gap-xl-1 {
    gap: 0.25rem !important;
  }
  .gap-xl-2 {
    gap: 0.5rem !important;
  }
  .gap-xl-3 {
    gap: 1rem !important;
  }
  .gap-xl-4 {
    gap: 1.5rem !important;
  }
  .gap-xl-5 {
    gap: 3rem !important;
  }
  .text-xl-start {
    text-align: left !important;
  }
  .text-xl-end {
    text-align: right !important;
  }
  .text-xl-center {
    text-align: center !important;
  }
}
@media (min-width: 1400px) {
  .float-xxl-start {
    float: left !important;
  }
  .float-xxl-end {
    float: right !important;
  }
  .float-xxl-none {
    float: none !important;
  }
  .d-xxl-inline {
    display: inline !important;
  }
  .d-xxl-inline-block {
    display: inline-block !important;
  }
  .d-xxl-block {
    display: block !important;
  }
  .d-xxl-grid {
    display: grid !important;
  }
  .d-xxl-table {
    display: table !important;
  }
  .d-xxl-table-row {
    display: table-row !important;
  }
  .d-xxl-table-cell {
    display: table-cell !important;
  }
  .d-xxl-flex {
    display: flex !important;
  }
  .d-xxl-inline-flex {
    display: inline-flex !important;
  }
  .d-xxl-none {
    display: none !important;
  }
  .flex-xxl-fill {
    flex: 1 1 auto !important;
  }
  .flex-xxl-row {
    flex-direction: row !important;
  }
  .flex-xxl-column {
    flex-direction: column !important;
  }
  .flex-xxl-row-reverse {
    flex-direction: row-reverse !important;
  }
  .flex-xxl-column-reverse {
    flex-direction: column-reverse !important;
  }
  .flex-xxl-grow-0 {
    flex-grow: 0 !important;
  }
  .flex-xxl-grow-1 {
    flex-grow: 1 !important;
  }
  .flex-xxl-shrink-0 {
    flex-shrink: 0 !important;
  }
  .flex-xxl-shrink-1 {
    flex-shrink: 1 !important;
  }
  .flex-xxl-wrap {
    flex-wrap: wrap !important;
  }
  .flex-xxl-nowrap {
    flex-wrap: nowrap !important;
  }
  .flex-xxl-wrap-reverse {
    flex-wrap: wrap-reverse !important;
  }
  .justify-content-xxl-start {
    justify-content: flex-start !important;
  }
  .justify-content-xxl-end {
    justify-content: flex-end !important;
  }
  .justify-content-xxl-center {
    justify-content: center !important;
  }
  .justify-content-xxl-between {
    justify-content: space-between !important;
  }
  .justify-content-xxl-around {
    justify-content: space-around !important;
  }
  .justify-content-xxl-evenly {
    justify-content: space-evenly !important;
  }
  .align-items-xxl-start {
    align-items: flex-start !important;
  }
  .align-items-xxl-end {
    align-items: flex-end !important;
  }
  .align-items-xxl-center {
    align-items: center !important;
  }
  .align-items-xxl-baseline {
    align-items: baseline !important;
  }
  .align-items-xxl-stretch {
    align-items: stretch !important;
  }
  .align-content-xxl-start {
    align-content: flex-start !important;
  }
  .align-content-xxl-end {
    align-content: flex-end !important;
  }
  .align-content-xxl-center {
    align-content: center !important;
  }
  .align-content-xxl-between {
    align-content: space-between !important;
  }
  .align-content-xxl-around {
    align-content: space-around !important;
  }
  .align-content-xxl-stretch {
    align-content: stretch !important;
  }
  .align-self-xxl-auto {
    align-self: auto !important;
  }
  .align-self-xxl-start {
    align-self: flex-start !important;
  }
  .align-self-xxl-end {
    align-self: flex-end !important;
  }
  .align-self-xxl-center {
    align-self: center !important;
  }
  .align-self-xxl-baseline {
    align-self: baseline !important;
  }
  .align-self-xxl-stretch {
    align-self: stretch !important;
  }
  .order-xxl-first {
    order: -1 !important;
  }
  .order-xxl-0 {
    order: 0 !important;
  }
  .order-xxl-1 {
    order: 1 !important;
  }
  .order-xxl-2 {
    order: 2 !important;
  }
  .order-xxl-3 {
    order: 3 !important;
  }
  .order-xxl-4 {
    order: 4 !important;
  }
  .order-xxl-5 {
    order: 5 !important;
  }
  .order-xxl-last {
    order: 6 !important;
  }
  .m-xxl-0 {
    margin: 0 !important;
  }
  .m-xxl-1 {
    margin: 0.25rem !important;
  }
  .m-xxl-2 {
    margin: 0.5rem !important;
  }
  .m-xxl-3 {
    margin: 1rem !important;
  }
  .m-xxl-4 {
    margin: 1.5rem !important;
  }
  .m-xxl-5 {
    margin: 3rem !important;
  }
  .m-xxl-auto {
    margin: auto !important;
  }
  .mx-xxl-0 {
    margin-right: 0 !important;
    margin-left: 0 !important;
  }
  .mx-xxl-1 {
    margin-right: 0.25rem !important;
    margin-left: 0.25rem !important;
  }
  .mx-xxl-2 {
    margin-right: 0.5rem !important;
    margin-left: 0.5rem !important;
  }
  .mx-xxl-3 {
    margin-right: 1rem !important;
    margin-left: 1rem !important;
  }
  .mx-xxl-4 {
    margin-right: 1.5rem !important;
    margin-left: 1.5rem !important;
  }
  .mx-xxl-5 {
    margin-right: 3rem !important;
    margin-left: 3rem !important;
  }
  .mx-xxl-auto {
    margin-right: auto !important;
    margin-left: auto !important;
  }
  .my-xxl-0 {
    margin-top: 0 !important;
    margin-bottom: 0 !important;
  }
  .my-xxl-1 {
    margin-top: 0.25rem !important;
    margin-bottom: 0.25rem !important;
  }
  .my-xxl-2 {
    margin-top: 0.5rem !important;
    margin-bottom: 0.5rem !important;
  }
  .my-xxl-3 {
    margin-top: 1rem !important;
    margin-bottom: 1rem !important;
  }
  .my-xxl-4 {
    margin-top: 1.5rem !important;
    margin-bottom: 1.5rem !important;
  }
  .my-xxl-5 {
    margin-top: 3rem !important;
    margin-bottom: 3rem !important;
  }
  .my-xxl-auto {
    margin-top: auto !important;
    margin-bottom: auto !important;
  }
  .mt-xxl-0 {
    margin-top: 0 !important;
  }
  .mt-xxl-1 {
    margin-top: 0.25rem !important;
  }
  .mt-xxl-2 {
    margin-top: 0.5rem !important;
  }
  .mt-xxl-3 {
    margin-top: 1rem !important;
  }
  .mt-xxl-4 {
    margin-top: 1.5rem !important;
  }
  .mt-xxl-5 {
    margin-top: 3rem !important;
  }
  .mt-xxl-auto {
    margin-top: auto !important;
  }
  .me-xxl-0 {
    margin-right: 0 !important;
  }
  .me-xxl-1 {
    margin-right: 0.25rem !important;
  }
  .me-xxl-2 {
    margin-right: 0.5rem !important;
  }
  .me-xxl-3 {
    margin-right: 1rem !important;
  }
  .me-xxl-4 {
    margin-right: 1.5rem !important;
  }
  .me-xxl-5 {
    margin-right: 3rem !important;
  }
  .me-xxl-auto {
    margin-right: auto !important;
  }
  .mb-xxl-0 {
    margin-bottom: 0 !important;
  }
  .mb-xxl-1 {
    margin-bottom: 0.25rem !important;
  }
  .mb-xxl-2 {
    margin-bottom: 0.5rem !important;
  }
  .mb-xxl-3 {
    margin-bottom: 1rem !important;
  }
  .mb-xxl-4 {
    margin-bottom: 1.5rem !important;
  }
  .mb-xxl-5 {
    margin-bottom: 3rem !important;
  }
  .mb-xxl-auto {
    margin-bottom: auto !important;
  }
  .ms-xxl-0 {
    margin-left: 0 !important;
  }
  .ms-xxl-1 {
    margin-left: 0.25rem !important;
  }
  .ms-xxl-2 {
    margin-left: 0.5rem !important;
  }
  .ms-xxl-3 {
    margin-left: 1rem !important;
  }
  .ms-xxl-4 {
    margin-left: 1.5rem !important;
  }
  .ms-xxl-5 {
    margin-left: 3rem !important;
  }
  .ms-xxl-auto {
    margin-left: auto !important;
  }
  .p-xxl-0 {
    padding: 0 !important;
  }
  .p-xxl-1 {
    padding: 0.25rem !important;
  }
  .p-xxl-2 {
    padding: 0.5rem !important;
  }
  .p-xxl-3 {
    padding: 1rem !important;
  }
  .p-xxl-4 {
    padding: 1.5rem !important;
  }
  .p-xxl-5 {
    padding: 3rem !important;
  }
  .px-xxl-0 {
    padding-right: 0 !important;
    padding-left: 0 !important;
  }
  .px-xxl-1 {
    padding-right: 0.25rem !important;
    padding-left: 0.25rem !important;
  }
  .px-xxl-2 {
    padding-right: 0.5rem !important;
    padding-left: 0.5rem !important;
  }
  .px-xxl-3 {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
  }
  .px-xxl-4 {
    padding-right: 1.5rem !important;
    padding-left: 1.5rem !important;
  }
  .px-xxl-5 {
    padding-right: 3rem !important;
    padding-left: 3rem !important;
  }
  .py-xxl-0 {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
  }
  .py-xxl-1 {
    padding-top: 0.25rem !important;
    padding-bottom: 0.25rem !important;
  }
  .py-xxl-2 {
    padding-top: 0.5rem !important;
    padding-bottom: 0.5rem !important;
  }
  .py-xxl-3 {
    padding-top: 1rem !important;
    padding-bottom: 1rem !important;
  }
  .py-xxl-4 {
    padding-top: 1.5rem !important;
    padding-bottom: 1.5rem !important;
  }
  .py-xxl-5 {
    padding-top: 3rem !important;
    padding-bottom: 3rem !important;
  }
  .pt-xxl-0 {
    padding-top: 0 !important;
  }
  .pt-xxl-1 {
    padding-top: 0.25rem !important;
  }
  .pt-xxl-2 {
    padding-top: 0.5rem !important;
  }
  .pt-xxl-3 {
    padding-top: 1rem !important;
  }
  .pt-xxl-4 {
    padding-top: 1.5rem !important;
  }
  .pt-xxl-5 {
    padding-top: 3rem !important;
  }
  .pe-xxl-0 {
    padding-right: 0 !important;
  }
  .pe-xxl-1 {
    padding-right: 0.25rem !important;
  }
  .pe-xxl-2 {
    padding-right: 0.5rem !important;
  }
  .pe-xxl-3 {
    padding-right: 1rem !important;
  }
  .pe-xxl-4 {
    padding-right: 1.5rem !important;
  }
  .pe-xxl-5 {
    padding-right: 3rem !important;
  }
  .pb-xxl-0 {
    padding-bottom: 0 !important;
  }
  .pb-xxl-1 {
    padding-bottom: 0.25rem !important;
  }
  .pb-xxl-2 {
    padding-bottom: 0.5rem !important;
  }
  .pb-xxl-3 {
    padding-bottom: 1rem !important;
  }
  .pb-xxl-4 {
    padding-bottom: 1.5rem !important;
  }
  .pb-xxl-5 {
    padding-bottom: 3rem !important;
  }
  .ps-xxl-0 {
    padding-left: 0 !important;
  }
  .ps-xxl-1 {
    padding-left: 0.25rem !important;
  }
  .ps-xxl-2 {
    padding-left: 0.5rem !important;
  }
  .ps-xxl-3 {
    padding-left: 1rem !important;
  }
  .ps-xxl-4 {
    padding-left: 1.5rem !important;
  }
  .ps-xxl-5 {
    padding-left: 3rem !important;
  }
  .gap-xxl-0 {
    gap: 0 !important;
  }
  .gap-xxl-1 {
    gap: 0.25rem !important;
  }
  .gap-xxl-2 {
    gap: 0.5rem !important;
  }
  .gap-xxl-3 {
    gap: 1rem !important;
  }
  .gap-xxl-4 {
    gap: 1.5rem !important;
  }
  .gap-xxl-5 {
    gap: 3rem !important;
  }
  .text-xxl-start {
    text-align: left !important;
  }
  .text-xxl-end {
    text-align: right !important;
  }
  .text-xxl-center {
    text-align: center !important;
  }
}
@media (min-width: 1200px) {
  .fs-1 {
    font-size: 2.5rem !important;
  }
  .fs-2 {
    font-size: 2rem !important;
  }
  .fs-3 {
    font-size: 1.75rem !important;
  }
  .fs-4 {
    font-size: 1.5rem !important;
  }
}
@media print {
  .d-print-inline {
    display: inline !important;
  }
  .d-print-inline-block {
    display: inline-block !important;
  }
  .d-print-block {
    display: block !important;
  }
  .d-print-grid {
    display: grid !important;
  }
  .d-print-table {
    display: table !important;
  }
  .d-print-table-row {
    display: table-row !important;
  }
  .d-print-table-cell {
    display: table-cell !important;
  }
  .d-print-flex {
    display: flex !important;
  }
  .d-print-inline-flex {
    display: inline-flex !important;
  }
  .d-print-none {
    display: none !important;
  }
}

/*# sourceMappingURL=bootstrap.css.map */
</style>
    <style>
      img {
  width: 120px;
  height: 120px;
}
body {
  font-size: 16px !important;
}

.table-borderless, .table-borderless tr, .table-borderless tr td{
  border: none!important;
}

footer {
  border-top: 4px #555 dotted;
}

td{
  text-align: center;
  vertical-align: middle;
  padding: 0!important;
  width: 33.333333%;
  font-size: 16px;
}
table tr td{
  padding: 0!important;
}
tr td:last-child{
  text-align: left;
  direction: ltr;
}
tr td:first-child{
  direction: rtl;
  text-align: right;
}
tr td:last-child, tr td:first-child{
  font-weight: bold;
}
thead tr td{
  font-weight: bold;
}

.body-one table,.body-one table tr,.body-one table tr td{
  vertical-align: middle!important;
  text-align: center!important;
}
.table-bordered,.table-bordered tr,.table-bordered tr td{
  border-color: black!important;
}
table.table-borderless,table.table-borderless tr,table.table-borderless tr td, table.table-borderless thead, table.table-borderless tbody, .white-borers, .white-borers>tr, .white-borers>tr>td{
  border-color: white!important;
}

.body-one tbody{
  border-top-width: 1px!important;
}
.body-one .tbody tr td{
  font-weight: normal;
}
    </style>
  </head>
  <body class="invoice py-2">
    <div class="container">

<header class="header">

    <table class="table table-borderless mb-3" border="0" cellspacing="0" cellpadding="0"
    >
        <tbody>
            <tr>
                <td>الشركة الوطنية للماء</td>
                <td class="pb-2"><img src="data:image/png;base64,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" /></td>
                <td>Société Nationale D'Eau (SNDE)</td>
            </tr>
            <tr>
                <td>لإصلاح الأعطاب والاستعلامات الاتصال بالأرقام:</td>
                <td dir="ltr">45 25 0 63 - 80001515</td>
                <td>Dépannage nuits et jours:</td>
            </tr>
            <tr>
                <td>الموقع الألكترونى:</td>
                <td dir="ltr"><a href="http://www.snde.mr">www.snde.mr</a></td>
                <td>Site Web:</td>
            </tr>""";
    try {
      String username = 'newsndemobile';
      String password = 'yKAFP9hmZARNnCm';
      Map<String, String> headers = {
        'authorization':
            'Basic ' + base64.encode(utf8.encode('$username:$password')),
      };
      http.Response responseDetails = await http.get(
          Uri.parse('$apiUrl/get-fact-header-detail?vref=$_code'),
          headers: headers);

      http.Response responseUser = await http.get(
          Uri.parse('$apiUrl/get-info-user?vref=$_code'),
          headers: headers);
      final codeResponseDetails = responseDetails.statusCode;
      final codeResponseUser = responseUser.statusCode;
      if (codeResponseUser == 200 && codeResponseDetails == 200) {
        final resultUser = json.decode(responseUser.body);
        final resultDetails = json.decode(responseDetails.body);
        var nom = resultUser['nom'];
        var abnAdresse = resultUser['abnAdresse'];

        var centre = resultDetails['centre'];
        var dateFact = resultDetails['dateFact'];

        var numFact = resultDetails['numFact'];
        html = html +
            """            <tr>
                <td>المركز:</td>
                <td dir="ltr">$centre</td>
                <td>Centre:</td>
            </tr>
            <tr>""";
        if (numFact != null) {
          var parts = dateFact.split('/');
          var month = parts[1];
          var year = parts[2];
          html = html +
              """<td>شهر الكشف على العداد:</td>
                    <td dir="ltr">$month-$year</td>
                
                <td>Mois de relève:</td>
                    </tr>
                </tbody>
            </table>""";
        }
        html = html +
            """
        <table class="table table-borderless mb-3" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td>الزبون:</td>
              <td dir="ltr">$nom</td>
              <td>Client:</td>
            </tr>
            <tr>
              <td>عقد الإشتراك:</td>
              <td dir="ltr">$_code</td>
              <td>Réf Abonnement:</td>
            </tr>
            <tr>
              <td>العنوان:</td>
              <td dir="ltr">$abnAdresse</td>
              <td>Adresse:</td>
            </tr>
          </tbody>
        </table>
        """;

        html = html +
            """
        <table class="table table-borderless mb-2" border="0" cellspacing="0" cellpadding="0">
        <tbody>
          <tr>
            <td dir="ltr" style="font-weight: bold;width: 100%!important; text-align: center">
              <span>Facture</span>
              <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
              <span>فاتورة الإستهلاك</span>
            </td>
          </tr>
        </tbody>
      </table></header>""";

        var comptage = resultDetails['comptage'];
        var consommation = resultDetails['consommation'];
        var dateAncienIndex = resultDetails['dateAncienIndex'];
        var ancIndex = resultDetails['ancIndex'];
        var dateNvIndex = resultDetails['dateNvIndex'];
        var nvIndex = resultDetails['nvIndex'];
        var numCpt = resultDetails['numCpt'];

        html = html +
            """
              <section class="body-one mb-4">
              <table class="table table-sm table-bordered mb-3">
                <thead>
                  <tr>
                    <td>حالة العداد</td>
                    <td>الإستهلاك</td>
                    <td>المؤشر القديم</td>
                    <td colspan="2" style="min-width: 208px;">المؤشر الجديد</td>
                    <td>رقم العداد</td>
                  </tr>
                  <tr>
                    <td>Commentaire</td>
                    <td>Consommation</td>
                    <td colspan="2">Ancien index relevé</td>
                    <td colspan="2">Nouveau index relevé</td>
                    <td style="padding: 0!important;white-space: nowrap;">Numéro<br>du Compteur</td>
                  </tr>
                  <tr>
                    <td>$comptage</td>
                    <td></td>
                    <td>المؤشر<br>Index</td>
                    <td>التاريخ<br>Date</td>
                    <td>المؤشر<br>Index</td>
                    <td>التاريخ<br>Date</td>
                    <td></td>
                  </tr>
                </thead>
                <tbody class="tbody">
                  <tr>
                    <td>$comptage</td>
                    <td>$consommation</td>
                    <td>$ancIndex</td>
                    <td>$dateAncienIndex</td>
                    <td>$nvIndex</td>
                    <td>$dateNvIndex</td>
                    <td>$numCpt</td>
                  </tr>
                </tbody>
              </table>

            </section>""";
        html = html +
            """
<section class="body-two">
  <table class="table table-bordered mb-3">
    <thead>
      <tr>
        <td class="text-nowrap text-center">المبلغ المتضمن <br>لجميع الضرائب</td>
        <td class="text-nowrap text-center">مبلغ ضريبة <br>القيمة المضافة</td>
        <td class="text-nowrap text-center">المبلغ من<br> دون ضرائب</td>
        <td class="text-nowrap text-center">السعر</td>
        <td class="text-nowrap text-center">الإستهلاك</td>
        <td class="text-center" style="min-width: 350px!important">البيان</td>
      </tr>
      <tr>
        <td class="text-nowrap text-center">Monetant TTC</td>
        <td class="text-nowrap text-center">Montant TVA</td>
        <td class="text-nowrap text-center">Montant HT</td>
        <td class="text-nowrap text-center">Pix Unitair</td>
        <td class="text-nowrap text-center">Consommation</td>
        <td class="text-center" style="min-width: 350px!important">Libelle</td>
      </tr>
    </thead>
    <tbody class="border-top-0">""";
        var facturesDetails = resultDetails['facturesDetails'];
        for (var row in facturesDetails) {
          var mntttc = row['mntttc'];
          var fdetTtva = row['fdetTtva'];
          var fdetPtht = row['fdetPtht'];
          var fdetPu = row['fdetPu'];
          var fdetQte = row['fdetQte'];
          var prdLibt = row['prdLibt'];
          html = html +
              """
      <tr>
        <td class="text-center" dir="ltr">$mntttc</td>
        <td class="text-center" dir="ltr">$fdetTtva</td>
        <td class="text-center" dir="ltr">$fdetPtht</td>
        <td class="text-center" dir="ltr">$fdetPu</td>
        <td class="text-center" dir="ltr">$fdetQte</td>
        <td class="text-center" style="min-width: 350px!important" dir="ltr">$prdLibt</td>
      </tr>""";
        }
        html = html +
            """</tbody>
  </table>""";

        var mntFact = resultDetails['mntFact'];
        var mntArr = resultDetails['mntArr'];
        var dateLimite = resultDetails['dateLimite'];
        var mntTtc = resultDetails['mntTtc'];

        html = html +
            """
        <table class="table table-sm table-bordered mb-3">
          <tr>
            <td class="text-center">$mntFact</td>
            <td class="text-nowrap text-center" colspan="2">TOTAL المجموع</td>
          </tr>
          <tr>
            <td class="text-center">$mntArr</td>
            <td class="text-center">$dateLimite</td>
            <td class="text-nowrap text-center">ARRIEREE AU متأخرات إلى غاية</td>
          </tr>
        </table>
        <table class="heaer-content table table-sm table-borderless mb-0 border-0" border="0" cellspacing="0" cellpadding="0">
          <tr class="border-0">
            <td class="border-0 text-center">$mntTtc</td>
            <td class="text-nowrap border-0 text-center">المبلغ المطلوب TOTAL NET A PAYER</td>
          </tr>
        </table>
      </section>""";
      }
    } catch (error) {
      showToast(t(context, 'no_result'));
    }
    html = html +
        """
      </div>
      </body>

      </html>""";
    return html;
  }

  Future<void> _showPdf() async {
    if (_gettingBalance || !_hasBalance) {
      return;
    }
    if (_hasPdf && doc != null) {
      Navigator.pushNamed(context, '/view_pdf', arguments: doc);
      return;
    }
    if (_showingPdf) {
      setState(() {
        _showingPdfLoading = true;
      });
      return;
    }
    setState(() {
      _showingPdf = true;
    });

    try {
      String html = await _generateHtml();
      String targetPath = (await getApplicationDocumentsDirectory()).path;
      //showToast(t(context, '$targetPath/${targetPath ?? ''}'));
      var targetFileName = '$_code';
      var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          html, targetPath, targetFileName);
      doc = generatedPdfFile.path;

      if (_showingPdfLoading) {
        Navigator.pushNamed(context, '/view_pdf', arguments: doc);
      }
      _hasPdf = true;
    } catch (error) {
      //showToast(t(context, '$error/${error ?? ''}'));
      showToast(t(context, 'no_result'));
    }

    setState(() {
      _showingPdfLoading = false;
      _showingPdf = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(t(context, 'account_balance')), centerTitle: true),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                if (_hasBalance)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.check,
                            color: Colors.green, size: 40),
                        SizedBox(height: 15),
                        Text('$name',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('${t(context, 'account_balance')}: $balance',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            // width: 12/0,
                            height: 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black54),
                              ),
                              onPressed: _gettingBalance || _showingPdfLoading
                                  ? null
                                  : _showPdf,
                              //,
                              child: _showingPdfLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(t(context, 'show_pdf')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: inputDecorationWidget(
                            text: t(context, 'reference'),
                            icon: FontAwesomeIcons.creditCard),
                        onChanged: (value) => setState(() {
                          _code = value;
                        }),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t(context, 'enter_reference');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: 150,
                          height: 55,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0)),
                            onPressed: _gettingBalance ? null : _checkBalance,
                            child: _gettingBalance
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(t(context, 'check_balance')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
