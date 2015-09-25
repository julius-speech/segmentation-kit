(Please Scroll down for Japanese text)

# Speech Segmentation Toolkit using Julius

## What's this?

This is a handy toolkit to do phoneme segmentation (aka phoneme alignments) for speech audio file using Julius.
Given pairs of speech audio file and its transcription, this toolkit perform Viterbi alignment to get the
beginning and ending time of each phoneme.

The output is saved in *WaveSurfer* Label Format, so you can view the
results in WaveSurfer.

Currently this toolkit supports only Japanese text/utterances, since we have only free acoustic model of Japanese.
However, the core engine is language-independent, so this can be run on other language if you prepare an acoustic model
for Julius.

## Requirement

- Windows
- Perl (ActivePerl, Perl for Windows, or mingw perl may work)

## Preparing data

Prepare audio file(.wav) and its transcription file(.txt), one by one.
For each audio file `foobar.wav`, a transcription file with the same base name should be prepared `foobar.txt`
Sample files `wav/sample.wav` and `wav/sample.txt` are included in the package.

- The audio file (.wav) should be in 16 kHz, 16 bit, PCM (no compression) WAV format.
- The transcription file (.txt) should be in UTF-8 encoding.

Transcription file should contain a phoneme sequence describing the content of the corresponding .wav file.  The phoneme set should corresponds to those in the acoustic model for the alignment.

If you want to insert long pauses within the certain point of the utterance, place `sp` (or
other equivalent pause model in the acoustic model) explicitly in the transcription.  If the pause model has skipping 
transition from initial state to last state, whether pause should be inserted or not will be determined automatically.

Head silence and Tail silence will be automatically inserted at execution.  You can inhibit this behavior by setting
```
$disable_silence_at_ends=0;
```
at `segment_julius.pl`.

For Japanese, Hiragana transciption will be accepted.  A simple Japanese Hiragana-to-phoneme rules are embedded in
the script so that the Hiragana transcription will be automatically converted into phoneme sequence.


## Run

- Place all the files (.wav and .txt) under `wav` directory.
- Run the `segment_julius.pl` script.

All the files in the `wav` directory will be processed, and each result will be saved in ".lab" file.
Also a detailed log from Julius will be saved in ".log" file.

The result file ".lab" is Transciption Label format for WaveSurfer.  You can view the result with the
Waveform by
- Open .wav file in wavesurfer,
- Do `Create Pane -> Transcription`,
- Choose .lab file.

## Note

The resulted alignment times are rounded to 10ms unit, since feature extraction is performed on 10ms shift.

---------------------------

# Julius 音素セグメンテーションキット

## はじめに

このキットはJulius を用いて音声ファイルの自動音素セグメンテーションを
行うキットです。日本語に対応しています。
  
## 動作要件

Windowsで動作確認しています。
動作には Perl が必要です。Perl for Windows　をインストールして下さい。
（動作確認は mingw で行いました）

## データの準備 ///////////////////////////////////////////////////

書き起こしを行う音声データファイル(.wav)と、それをひらがなで書き起こし
たテキストファイル(.txt)のペアをそれぞれ用意して同じファイル名で `wav`
ディレクトリ以下に置きます。サンプルが `wav/sample.wav` と
`wav/sample.txt` にあるので参考にして下さい。複数ファイルを一度に処理でき
ます。

音声ファイルは WAV形式で 16kHz, 16bit, PCM（無圧縮）形式である必要があり
ます。テキストファイルはテキスト形式で、文字コードは UTF-8です。

書き起こしテキストは「ひらがな」で１行で記述します。

    きょーわいいてんきです

文中にポーズを入れたいときは、その位置でスペースで区切って `sp` を入れて
下さい（自動挿入には対応していません）。

    きょーわ sp いいてんきです

ひらがなは内部で音素列に変換されます。変換がうまくいかないときは音素列
で直接指定することも可能です。

    ky o: w a i i t e N k i d e s u

実行時には文頭・文末に自動的に無音(`silB`, `silE`)を挿入してアラインメント
が行われます。この機能を止めたい場合は `segment_julius.pl` を編集します。
冒頭の

    $disable_silence_at_ends=0;

を 1 にセットしてから以下を実行してください。

## アラインメントの実行

1. 音声データファイルと書き起こしテキストファイルのペアを全て `wav` フォ
ルダ内に置く。

2. `segment_julius.pl` を実行する。

以上で、`wav` ディレクトリの全ての .wav ファイルに対してアラインメントが
実行され、ファイルごとの結果が ".lab" ファイルに格納されます。

また、Juliusの詳細なログが ".log" ファイルに保存されます。

## 結果の見方

.lab ファイルは wavesurfer の transcription フォーマットです。
wavesurfer で .wav ファイルを開いて Create Pane -> Transcription で
読み込まれて wavesurfer 上で結果を閲覧できます。


## 補足

本キットは日本語用にセットアップされていますが、他の言語用のJulius用音
響モデルを用意し、書き起こしテキストをその音響モデルで使用されている音
素セットの音素列で与えることで、他の言語でのアラインメントも可能です。

本キットでは音声データを25msのウィンドウで10msごとに切り出して特徴量に
変換しています。このためアラインメント結果は 10ms 単位で丸められた値と
なります。

