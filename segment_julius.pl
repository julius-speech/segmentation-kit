#!/usr/bin/perl
#
# forced alignment using Julius
#
# usage: segment_julius.pl dir
#
#   "dir" is a directory that contains waveform files and transcription files:
#
#     *.wav     Speech file (.wav, 16bit, 16kHz, PCM, no compression)
#     *.txt     Hiragana transcription of the speech file
#
#   All the *.wav data will be processed, and each result will be output
#   in these files:
#
#     *.lab     alignment result in Wavesurfer format
#
#   The following files are also output for debug:
#
#     *.log     julius log for debug
#     *.dfa     grammar file used by Julius
#     *.dict    dictionary file used by Julius
#
#   To see the results, open .wav file by wavesurfer and create
#   "Transciption" pane to see it.
#

use File::Basename 'fileparse';

######################################################################
######################################################################
#### configuration

## data directory
$datadir = "./wav";
if (defined $ARGV[0]) {
    $datadir = $ARGV[0];
}

## set to 1 to disable inserting silence at begin/end of sentence
$disable_silence_at_ends=0;

## DEBUG: set to 1 to keep generated dfa and dict file
$leave_dict_flag=0;

## DEBUG: set to 1 to output detailed julius debug message in log
$debug_flag=0;

## julius executable
if ($^O =~ /MSWin/){
    $juliusbin=".\\bin\\julius-4.3.1.exe";
} else {
    $juliusbin="./bin/julius-4.3.1";
}

## acoustic model
$hmmdefs="./models/hmmdefs_monof_mix16_gid.binhmm"; # monophone model
#$hmmdefs="./models/hmmdefs_ptm_gid.binhmm"; # triphone model

## HMMList file (needed for triphone model)
#$hlist="./models/logicalTri";

## other options to Julius if needed
$OPTARGS="-input file";	# raw speech file input
#$OPTARGS="-input htkparam";	# MFCC file input

## offset for result in ms: 25ms / 2
$offset_align = 0.0125;

######################################################################
######################################################################

#### read the directory
@files = ();
opendir $dh, $datadir or die "$!:$datadir";
while ($f = readdir $dh) {
    next unless $f =~ /\.(wav|WAV)$/;
    $filepath = "$datadir/$f";
    next unless -f $filepath;
    ($basename) = (fileparse($filepath, qr/\..*$/))[0];
    push(@files, "$datadir/$basename");
}
closedir $dh;

foreach $f (@files) {
    print $f . ".wav\n";

    ## read transcription and convert to phoneme sequence
    @words=();
    if ($disable_silence_at_ends == 0){
	push(@words, "silB");
    }
    open(TRANS, "$f.txt") || die "Error: cannot open transcription file \"$f.txt\"\n";
    while(<TRANS>) {
	chomp;
	next if /^[ \t\n]*$/;
	push(@words, &yomi2voca($_));
    }
    if ($disable_silence_at_ends == 0){
	push(@words, "silE");
    }
    close(TRANS);
    $num = $#words;

    # generate dfa and dict for Julius
    unlink("$f.dfa") if (-r "$f.dfa");
    unlink("$f.dict") if (-r "$f.dict");
    open(DFA, "> $f.dfa") || die "Error: cannot open $f.dfa for writing\n";
    for ($i = 0; $i <= $num; $i++) {
	$str = sprintf("%d %d %d 0", $i, $num - $i, $i + 1);
	if ($i == 0) {
	    $str .= " 1\n";
	} else {
	    $str .= " 0\n";
	}
	print DFA "$str";
    }
    $str = sprintf("%d -1 -1 1 0\n", $num + 1);
    print DFA "$str";
    close(DFA);
    open(DICT, "> $f.dict") || die "Error: cannot open $f.dict for writing\n";
    for ($i = 0; $i <= $num; $i++) {
	$w = shift(@words);
	$str = "$i [w_$i] $w\n";
	$WLIST{"w_$i"} = "$w";
	print DICT "$str";
    }
    close(DICT);
    if ((! -r "$f.dfa") || (! -f "$f.dfa")) {
	die "Error: failed to make \"$f.dfa\"\n";
    }
    if ((! -r "$f.dict") || (! -f "$f.dict")) {
	die "Error: failed to make \"$f.dict\"\n";
    }

    #### execute Julius and store the output to log
    $command = "echo $f.wav | $juliusbin -h $hmmdefs -dfa $f.dfa -v $f.dict";
    $command .= " -palign";
    if ($hlist ne "") {
	$command .= " -hlist $hlist";
    }
    $command .= " $OPTARGS";
    $command .= " -debug" if ($debug_flag != 0);
    system("$command > $f.log");

    if ($leave_dict_flag == 0) {
	unlink("$f.dfa") if (-r "$f.dfa");
	unlink("$f.dict") if (-r "$f.dict");
    }

    #### parse log and output result
    open(RESULT, "> $f.lab") || die "Error: cannot open result file \"$f.lab\"\n";
    open(LOG, "$f.log") || die "Error: cannot open $f.log file\n";
    $sw = 0;
    while(<LOG>) {
	chomp;
	if (/begin forced alignment/) {
	    $sw = 1;
	}
	if ($sw == 1 && /^\[/) {
	    if ($num > 0) {
		if(/\[(w_\d+)\]/){
		    $c_str = $1;
		    s/$c_str/$WLIST{$c_str}/;
		}
	    }
	    ($beginframe, $endframe, $unit) = /\[ *(\d+) *(\d+)\] *[0-9\.-]+ *(.*)$/;
	    $begintime = $beginframe * 0.01;
	    if ($beginframe != 0) {
		$begintime += $offset_align;
	    }
	    $endtime = ($endframe + 1) * 0.01 + $offset_align;
	    printf(RESULT "%.7f %.7f %s\n", $begintime, $endtime, $unit);
	}
	if (/end forced alignment/) {
	    $sw = 0;
	}
    }
    close(LOG);
    close(RESULT);

    print "Result saved in \"$f.lab\".\n";
}


sub yomi2voca {
    chomp;
# 3文字以上からなる変換規則
    s/う゛ぁ/ b a/g;
    s/う゛ぃ/ b i/g;
    s/う゛ぇ/ b e/g;
    s/う゛ぉ/ b o/g;
    s/う゛ゅ/ by u/g;

# 2文字からなる変換規則
    s/ぅ゛/ b u/g;

    s/あぁ/ a a/g;
    s/いぃ/ i i/g;
    s/いぇ/ i e/g;
    s/いゃ/ y a/g;
    s/うぅ/ u:/g;
    s/えぇ/ e e/g;
    s/おぉ/ o:/g;
    s/かぁ/ k a:/g;
    s/きぃ/ k i:/g;
    s/くぅ/ k u:/g;
    s/くゃ/ ky a/g;
    s/くゅ/ ky u/g;
    s/くょ/ ky o/g;
    s/けぇ/ k e:/g;
    s/こぉ/ k o:/g;
    s/がぁ/ g a:/g;
    s/ぎぃ/ g i:/g;
    s/ぐぅ/ g u:/g;
    s/ぐゃ/ gy a/g;
    s/ぐゅ/ gy u/g;
    s/ぐょ/ gy o/g;
    s/げぇ/ g e:/g;
    s/ごぉ/ g o:/g;
    s/さぁ/ s a:/g;
    s/しぃ/ sh i:/g;
    s/すぅ/ s u:/g;
    s/すゃ/ sh a/g;
    s/すゅ/ sh u/g;
    s/すょ/ sh o/g;
    s/せぇ/ s e:/g;
    s/そぉ/ s o:/g;
    s/ざぁ/ z a:/g;
    s/じぃ/ j i:/g;
    s/ずぅ/ z u:/g;
    s/ずゃ/ zy a/g;
    s/ずゅ/ zy u/g;
    s/ずょ/ zy o/g;
    s/ぜぇ/ z e:/g;
    s/ぞぉ/ z o:/g;
    s/たぁ/ t a:/g;
    s/ちぃ/ ch i:/g;
    s/つぁ/ ts a/g;
    s/つぃ/ ts i/g;
    s/つぅ/ ts u:/g;
    s/つゃ/ ch a/g;
    s/つゅ/ ch u/g;
    s/つょ/ ch o/g;
    s/つぇ/ ts e/g;
    s/つぉ/ ts o/g;
    s/てぇ/ t e:/g;
    s/とぉ/ t o:/g;
    s/だぁ/ d a:/g;
    s/ぢぃ/ j i:/g;
    s/づぅ/ d u:/g;
    s/づゃ/ zy a/g;
    s/づゅ/ zy u/g;
    s/づょ/ zy o/g;
    s/でぇ/ d e:/g;
    s/どぉ/ d o:/g;
    s/なぁ/ n a:/g;
    s/にぃ/ n i:/g;
    s/ぬぅ/ n u:/g;
    s/ぬゃ/ ny a/g;
    s/ぬゅ/ ny u/g;
    s/ぬょ/ ny o/g;
    s/ねぇ/ n e:/g;
    s/のぉ/ n o:/g;
    s/はぁ/ h a:/g;
    s/ひぃ/ h i:/g;
    s/ふぅ/ f u:/g;
    s/ふゃ/ hy a/g;
    s/ふゅ/ hy u/g;
    s/ふょ/ hy o/g;
    s/へぇ/ h e:/g;
    s/ほぉ/ h o:/g;
    s/ばぁ/ b a:/g;
    s/びぃ/ b i:/g;
    s/ぶぅ/ b u:/g;
    s/ふゃ/ hy a/g;
    s/ぶゅ/ by u/g;
    s/ふょ/ hy o/g;
    s/べぇ/ b e:/g;
    s/ぼぉ/ b o:/g;
    s/ぱぁ/ p a:/g;
    s/ぴぃ/ p i:/g;
    s/ぷぅ/ p u:/g;
    s/ぷゃ/ py a/g;
    s/ぷゅ/ py u/g;
    s/ぷょ/ py o/g;
    s/ぺぇ/ p e:/g;
    s/ぽぉ/ p o:/g;
    s/まぁ/ m a:/g;
    s/みぃ/ m i:/g;
    s/むぅ/ m u:/g;
    s/むゃ/ my a/g;
    s/むゅ/ my u/g;
    s/むょ/ my o/g;
    s/めぇ/ m e:/g;
    s/もぉ/ m o:/g;
    s/やぁ/ y a:/g;
    s/ゆぅ/ y u:/g;
    s/ゆゃ/ y a:/g;
    s/ゆゅ/ y u:/g;
    s/ゆょ/ y o:/g;
    s/よぉ/ y o:/g;
    s/らぁ/ r a:/g;
    s/りぃ/ r i:/g;
    s/るぅ/ r u:/g;
    s/るゃ/ ry a/g;
    s/るゅ/ ry u/g;
    s/るょ/ ry o/g;
    s/れぇ/ r e:/g;
    s/ろぉ/ r o:/g;
    s/わぁ/ w a:/g;
    s/をぉ/ o:/g;
    
    s/う゛/ b u/g;
    s/でぃ/ d i/g;
    s/でぇ/ d e:/g;
    s/でゃ/ dy a/g;
    s/でゅ/ dy u/g;
    s/でょ/ dy o/g;
    s/てぃ/ t i/g;
    s/てぇ/ t e:/g;
    s/てゃ/ ty a/g;
    s/てゅ/ ty u/g;
    s/てょ/ ty o/g;
    s/すぃ/ s i/g;
    s/ずぁ/ z u a/g;
    s/ずぃ/ z i/g;
    s/ずぅ/ z u/g;
    s/ずゃ/ zy a/g;
    s/ずゅ/ zy u/g;
    s/ずょ/ zy o/g;
    s/ずぇ/ z e/g;
    s/ずぉ/ z o/g;
    s/きゃ/ ky a/g;
    s/きゅ/ ky u/g;
    s/きょ/ ky o/g;
    s/しゃ/ sh a/g;
    s/しゅ/ sh u/g;
    s/しぇ/ sh e/g;
    s/しょ/ sh o/g;
    s/ちゃ/ ch a/g;
    s/ちゅ/ ch u/g;
    s/ちぇ/ ch e/g;
    s/ちょ/ ch o/g;
    s/とぅ/ t u/g;
    s/とゃ/ ty a/g;
    s/とゅ/ ty u/g;
    s/とょ/ ty o/g;
    s/どぁ/ d o a/g;
    s/どぅ/ d u/g;
    s/どゃ/ dy a/g;
    s/どゅ/ dy u/g;
    s/どょ/ dy o/g;
    s/どぉ/ d o:/g;
    s/にゃ/ ny a/g;
    s/にゅ/ ny u/g;
    s/にょ/ ny o/g;
    s/ひゃ/ hy a/g;
    s/ひゅ/ hy u/g;
    s/ひょ/ hy o/g;
    s/みゃ/ my a/g;
    s/みゅ/ my u/g;
    s/みょ/ my o/g;
    s/りゃ/ ry a/g;
    s/りゅ/ ry u/g;
    s/りょ/ ry o/g;
    s/ぎゃ/ gy a/g;
    s/ぎゅ/ gy u/g;
    s/ぎょ/ gy o/g;
    s/ぢぇ/ j e/g;
    s/ぢゃ/ j a/g;
    s/ぢゅ/ j u/g;
    s/ぢょ/ j o/g;
    s/じぇ/ j e/g;
    s/じゃ/ j a/g;
    s/じゅ/ j u/g;
    s/じょ/ j o/g;
    s/びゃ/ by a/g;
    s/びゅ/ by u/g;
    s/びょ/ by o/g;
    s/ぴゃ/ py a/g;
    s/ぴゅ/ py u/g;
    s/ぴょ/ py o/g;
    s/うぁ/ u a/g;
    s/うぃ/ w i/g;
    s/うぇ/ w e/g;
    s/うぉ/ w o/g;
    s/ふぁ/ f a/g;
    s/ふぃ/ f i/g;
    s/ふぅ/ f u/g;
    s/ふゃ/ hy a/g;
    s/ふゅ/ hy u/g;
    s/ふょ/ hy o/g;
    s/ふぇ/ f e/g;
    s/ふぉ/ f o/g;

# 1音からなる変換規則
    s/あ/ a/g;
    s/い/ i/g;
    s/う/ u/g;
    s/え/ e/g;
    s/お/ o/g;
    s/か/ k a/g;
    s/き/ k i/g;
    s/く/ k u/g;
    s/け/ k e/g;
    s/こ/ k o/g;
    s/さ/ s a/g;
    s/し/ sh i/g;
    s/す/ s u/g;
    s/せ/ s e/g;
    s/そ/ s o/g;
    s/た/ t a/g;
    s/ち/ ch i/g;
    s/つ/ ts u/g;
    s/て/ t e/g;
    s/と/ t o/g;
    s/な/ n a/g;
    s/に/ n i/g;
    s/ぬ/ n u/g;
    s/ね/ n e/g;
    s/の/ n o/g;
    s/は/ h a/g;
    s/ひ/ h i/g;
    s/ふ/ f u/g;
    s/へ/ h e/g;
    s/ほ/ h o/g;
    s/ま/ m a/g;
    s/み/ m i/g;
    s/む/ m u/g;
    s/め/ m e/g;
    s/も/ m o/g;
    s/ら/ r a/g;
    s/り/ r i/g;
    s/る/ r u/g;
    s/れ/ r e/g;
    s/ろ/ r o/g;
    s/が/ g a/g;
    s/ぎ/ g i/g;
    s/ぐ/ g u/g;
    s/げ/ g e/g;
    s/ご/ g o/g;
    s/ざ/ z a/g;
    s/じ/ j i/g;
    s/ず/ z u/g;
    s/ぜ/ z e/g;
    s/ぞ/ z o/g;
    s/だ/ d a/g;
    s/ぢ/ j i/g;
    s/づ/ z u/g;
    s/で/ d e/g;
    s/ど/ d o/g;
    s/ば/ b a/g;
    s/び/ b i/g;
    s/ぶ/ b u/g;
    s/べ/ b e/g;
    s/ぼ/ b o/g;
    s/ぱ/ p a/g;
    s/ぴ/ p i/g;
    s/ぷ/ p u/g;
    s/ぺ/ p e/g;
    s/ぽ/ p o/g;
    s/や/ y a/g;
    s/ゆ/ y u/g;
    s/よ/ y o/g;
    s/わ/ w a/g;
    s/ゐ/ i/g;
    s/ゑ/ e/g;
    s/ん/ N/g;
    s/っ/ q/g;
    s/ー/:/g;

# ここまでに処理されてない ぁぃぅぇぉ はそのまま大文字扱い
    s/ぁ/ a/g;
    s/ぃ/ i/g;
    s/ぅ/ u/g;
    s/ぇ/ e/g;
    s/ぉ/ o/g;
    s/ゎ/ w a/g;
    s/ぉ/ o/g;

#その他特別なルール
    s/を/ o/g;

    s/^ ([a-z])/$1/g;
    s/:+/:/g;

    if (! /^[ a-zA-Z:]+$/) {
	print STDERR "$_\n";
    }

    return $_;
}
    
