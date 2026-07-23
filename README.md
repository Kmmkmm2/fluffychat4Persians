FluffyChat for Persians
An unofficial fork of FluffyChat
with proper bidirectional (RTL/LTR) text rendering.
This is not the official FluffyChat. It is not affiliated with or
endorsed by the FluffyChat project or its maintainers. Please do not
report bugs from this build to the upstream project.


فارسی


فلافی‌چت یک کلاینت متن‌باز و امن برای شبکه Matrix است. اما در نمایش
جمله‌هایی که فارسی و انگلیسی را با هم ترکیب می‌کنند مشکل دارد و ترتیب
کلمات به هم می‌ریزد.

این فورک دقیقاً همین یک مشکل را حل می‌کند. تمام قابلیت‌های دیگر
دست‌نخورده باقی مانده‌اند.
تفاوت با نسخه رسمی
جهت هر پیام از روی خود متن تشخیص داده می‌شود، نه از زبان برنامه
حباب پیام‌ها، کادر تایپ و پیش‌نمایش ریپلای هر سه اصلاح شده‌اند
نام، آیکون و شناسه بسته تغییر کرده تا در کنار نسخه رسمی نصب شود
دانلود
فایل APK را از بخش Releases بگیرید.
هنگام نصب، اندروید هشدار می‌دهد که منبع برنامه ناشناس است. این برای
همه برنامه‌هایی که خارج از Google Play نصب می‌شوند طبیعی است.


English


What is different from upstream
Messages that mix a right-to-left script (Persian, Arabic, Hebrew) with
latin words are reordered by the Unicode bidi algorithm, because Flutter
derives the base paragraph direction from Directionality.of(context) —
which follows the app locale rather than the message.
This fork detects the base direction from the message content itself,
following UAX #9 rules P2/P3: the first strong character wins, neutral
characters are skipped, and anything inside a bidi isolate is ignored.
Applied in three places:
File
What it fixes
lib/utils/text_direction_extension.dart
New — the detection logic
lib/pages/chat/events/html_message.dart
Message bubbles
lib/pages/chat/input_bar.dart
The composer, updated live as you type
lib/pages/chat/events/reply_content.dart
Reply previews
The app name, launcher icon and application ID are also changed, so this
build installs alongside the official app instead of replacing it.
Nothing else is modified.
Upstream
The underlying bug is tracked upstream. If you want this fixed for
everyone, support the issue there rather than relying on this fork.
License
FluffyChat is licensed under the AGPL-3.0-or-later, and so is this
fork. See LICENSE.
Original work: Copyright © Christian Kußowski and contributors to
FluffyChat. This is a modified version; the changes described above were
made by the maintainer of this repository.
The FluffyChat name and logo belong to the upstream project and are not
used by this build.
