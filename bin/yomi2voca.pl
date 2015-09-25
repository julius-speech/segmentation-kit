#!/usr/bin/perl
# Copyright (c) 1991-2006 Kawahara Lab., Kyoto University
# Copyright (c) 2000-2005 Shikano Lab., Nara Institute of Science and Technology
# Copyright (c) 2005-2006 Julius project team, Nagoya Institute of Technology, Nagoya Institute of Technology
# All rights reserved
#
# Generated automatically from yomi2voca.pl.in by configure. 
#

# ¤Ò¤é¤¬¤Ê -> ROMAN(É¸½à·Á¼°) ÊÑ´¹¥¹¥¯¥ê¥×¥È
#   .yomi -> .voca


while (<>) {
    chomp;
# 3Ê¸»ú°Ê¾å¤«¤é¤Ê¤ëÊÑ´¹µ¬Â§
    s/¤¦¡«¤¡/ b a/g;
    s/¤¦¡«¤£/ b i/g;
    s/¤¦¡«¤§/ b e/g;
    s/¤¦¡«¤©/ b o/g;
    s/¤¦¡«¤å/ by u/g;

# 2Ê¸»ú¤«¤é¤Ê¤ëÊÑ´¹µ¬Â§
    s/¤¥¡«/ b u/g;

    s/¤¢¤¡/ a a/g;
    s/¤¤¤£/ i i/g;
    s/¤¤¤§/ i e/g;
    s/¤¤¤ã/ y a/g;
    s/¤¦¤¥/ u:/g;
    s/¤¨¤§/ e e/g;
    s/¤ª¤©/ o:/g;
    s/¤«¤¡/ k a:/g;
    s/¤­¤£/ k i:/g;
    s/¤¯¤¥/ k u:/g;
    s/¤¯¤ã/ ky a/g;
    s/¤¯¤å/ ky u/g;
    s/¤¯¤ç/ ky o/g;
    s/¤±¤§/ k e:/g;
    s/¤³¤©/ k o:/g;
    s/¤¬¤¡/ g a:/g;
    s/¤®¤£/ g i:/g;
    s/¤°¤¥/ g u:/g;
    s/¤°¤ã/ gy a/g;
    s/¤°¤å/ gy u/g;
    s/¤°¤ç/ gy o/g;
    s/¤²¤§/ g e:/g;
    s/¤´¤©/ g o:/g;
    s/¤µ¤¡/ s a:/g;
    s/¤·¤£/ sh i:/g;
    s/¤¹¤¥/ s u:/g;
    s/¤¹¤ã/ sh a/g;
    s/¤¹¤å/ sh u/g;
    s/¤¹¤ç/ sh o/g;
    s/¤»¤§/ s e:/g;
    s/¤½¤©/ s o:/g;
    s/¤¶¤¡/ z a:/g;
    s/¤¸¤£/ j i:/g;
    s/¤º¤¥/ z u:/g;
    s/¤º¤ã/ zy a/g;
    s/¤º¤å/ zy u/g;
    s/¤º¤ç/ zy o/g;
    s/¤¼¤§/ z e:/g;
    s/¤¾¤©/ z o:/g;
    s/¤¿¤¡/ t a:/g;
    s/¤Á¤£/ ch i:/g;
    s/¤Ä¤¡/ ts a/g;
    s/¤Ä¤£/ ts i/g;
    s/¤Ä¤¥/ ts u:/g;
    s/¤Ä¤ã/ ch a/g;
    s/¤Ä¤å/ ch u/g;
    s/¤Ä¤ç/ ch o/g;
    s/¤Ä¤§/ ts e/g;
    s/¤Ä¤©/ ts o/g;
    s/¤Æ¤§/ t e:/g;
    s/¤È¤©/ t o:/g;
    s/¤À¤¡/ d a:/g;
    s/¤Â¤£/ j i:/g;
    s/¤Å¤¥/ d u:/g;
    s/¤Å¤ã/ zy a/g;
    s/¤Å¤å/ zy u/g;
    s/¤Å¤ç/ zy o/g;
    s/¤Ç¤§/ d e:/g;
    s/¤É¤©/ d o:/g;
    s/¤Ê¤¡/ n a:/g;
    s/¤Ë¤£/ n i:/g;
    s/¤Ì¤¥/ n u:/g;
    s/¤Ì¤ã/ ny a/g;
    s/¤Ì¤å/ ny u/g;
    s/¤Ì¤ç/ ny o/g;
    s/¤Í¤§/ n e:/g;
    s/¤Î¤©/ n o:/g;
    s/¤Ï¤¡/ h a:/g;
    s/¤Ò¤£/ h i:/g;
    s/¤Õ¤¥/ f u:/g;
    s/¤Õ¤ã/ hy a/g;
    s/¤Õ¤å/ hy u/g;
    s/¤Õ¤ç/ hy o/g;
    s/¤Ø¤§/ h e:/g;
    s/¤Û¤©/ h o:/g;
    s/¤Ð¤¡/ b a:/g;
    s/¤Ó¤£/ b i:/g;
    s/¤Ö¤¥/ b u:/g;
    s/¤Õ¤ã/ hy a/g;
    s/¤Ö¤å/ by u/g;
    s/¤Õ¤ç/ hy o/g;
    s/¤Ù¤§/ b e:/g;
    s/¤Ü¤©/ b o:/g;
    s/¤Ñ¤¡/ p a:/g;
    s/¤Ô¤£/ p i:/g;
    s/¤×¤¥/ p u:/g;
    s/¤×¤ã/ py a/g;
    s/¤×¤å/ py u/g;
    s/¤×¤ç/ py o/g;
    s/¤Ú¤§/ p e:/g;
    s/¤Ý¤©/ p o:/g;
    s/¤Þ¤¡/ m a:/g;
    s/¤ß¤£/ m i:/g;
    s/¤à¤¥/ m u:/g;
    s/¤à¤ã/ my a/g;
    s/¤à¤å/ my u/g;
    s/¤à¤ç/ my o/g;
    s/¤á¤§/ m e:/g;
    s/¤â¤©/ m o:/g;
    s/¤ä¤¡/ y a:/g;
    s/¤æ¤¥/ y u:/g;
    s/¤æ¤ã/ y a:/g;
    s/¤æ¤å/ y u:/g;
    s/¤æ¤ç/ y o:/g;
    s/¤è¤©/ y o:/g;
    s/¤é¤¡/ r a:/g;
    s/¤ê¤£/ r i:/g;
    s/¤ë¤¥/ r u:/g;
    s/¤ë¤ã/ ry a/g;
    s/¤ë¤å/ ry u/g;
    s/¤ë¤ç/ ry o/g;
    s/¤ì¤§/ r e:/g;
    s/¤í¤©/ r o:/g;
    s/¤ï¤¡/ w a:/g;
    s/¤ò¤©/ o:/g;
    
    s/¤¦¡«/ b u/g;
    s/¤Ç¤£/ d i/g;
    s/¤Ç¤§/ d e:/g;
    s/¤Ç¤ã/ dy a/g;
    s/¤Ç¤å/ dy u/g;
    s/¤Ç¤ç/ dy o/g;
    s/¤Æ¤£/ t i/g;
    s/¤Æ¤§/ t e:/g;
    s/¤Æ¤ã/ ty a/g;
    s/¤Æ¤å/ ty u/g;
    s/¤Æ¤ç/ ty o/g;
    s/¤¹¤£/ s i/g;
    s/¤º¤¡/ z u a/g;
    s/¤º¤£/ z i/g;
    s/¤º¤¥/ z u/g;
    s/¤º¤ã/ zy a/g;
    s/¤º¤å/ zy u/g;
    s/¤º¤ç/ zy o/g;
    s/¤º¤§/ z e/g;
    s/¤º¤©/ z o/g;
    s/¤­¤ã/ ky a/g;
    s/¤­¤å/ ky u/g;
    s/¤­¤ç/ ky o/g;
    s/¤·¤ã/ sh a/g;
    s/¤·¤å/ sh u/g;
    s/¤·¤§/ sh e/g;
    s/¤·¤ç/ sh o/g;
    s/¤Á¤ã/ ch a/g;
    s/¤Á¤å/ ch u/g;
    s/¤Á¤§/ ch e/g;
    s/¤Á¤ç/ ch o/g;
    s/¤È¤¥/ t u/g;
    s/¤È¤ã/ ty a/g;
    s/¤È¤å/ ty u/g;
    s/¤È¤ç/ ty o/g;
    s/¤É¤¡/ d o a/g;
    s/¤É¤¥/ d u/g;
    s/¤É¤ã/ dy a/g;
    s/¤É¤å/ dy u/g;
    s/¤É¤ç/ dy o/g;
    s/¤É¤©/ d o:/g;
    s/¤Ë¤ã/ ny a/g;
    s/¤Ë¤å/ ny u/g;
    s/¤Ë¤ç/ ny o/g;
    s/¤Ò¤ã/ hy a/g;
    s/¤Ò¤å/ hy u/g;
    s/¤Ò¤ç/ hy o/g;
    s/¤ß¤ã/ my a/g;
    s/¤ß¤å/ my u/g;
    s/¤ß¤ç/ my o/g;
    s/¤ê¤ã/ ry a/g;
    s/¤ê¤å/ ry u/g;
    s/¤ê¤ç/ ry o/g;
    s/¤®¤ã/ gy a/g;
    s/¤®¤å/ gy u/g;
    s/¤®¤ç/ gy o/g;
    s/¤Â¤§/ j e/g;
    s/¤Â¤ã/ j a/g;
    s/¤Â¤å/ j u/g;
    s/¤Â¤ç/ j o/g;
    s/¤¸¤§/ j e/g;
    s/¤¸¤ã/ j a/g;
    s/¤¸¤å/ j u/g;
    s/¤¸¤ç/ j o/g;
    s/¤Ó¤ã/ by a/g;
    s/¤Ó¤å/ by u/g;
    s/¤Ó¤ç/ by o/g;
    s/¤Ô¤ã/ py a/g;
    s/¤Ô¤å/ py u/g;
    s/¤Ô¤ç/ py o/g;
    s/¤¦¤¡/ u a/g;
    s/¤¦¤£/ w i/g;
    s/¤¦¤§/ w e/g;
    s/¤¦¤©/ w o/g;
    s/¤Õ¤¡/ f a/g;
    s/¤Õ¤£/ f i/g;
    s/¤Õ¤¥/ f u/g;
    s/¤Õ¤ã/ hy a/g;
    s/¤Õ¤å/ hy u/g;
    s/¤Õ¤ç/ hy o/g;
    s/¤Õ¤§/ f e/g;
    s/¤Õ¤©/ f o/g;

# 1²»¤«¤é¤Ê¤ëÊÑ´¹µ¬Â§
    s/¤¢/ a/g;
    s/¤¤/ i/g;
    s/¤¦/ u/g;
    s/¤¨/ e/g;
    s/¤ª/ o/g;
    s/¤«/ k a/g;
    s/¤­/ k i/g;
    s/¤¯/ k u/g;
    s/¤±/ k e/g;
    s/¤³/ k o/g;
    s/¤µ/ s a/g;
    s/¤·/ sh i/g;
    s/¤¹/ s u/g;
    s/¤»/ s e/g;
    s/¤½/ s o/g;
    s/¤¿/ t a/g;
    s/¤Á/ ch i/g;
    s/¤Ä/ ts u/g;
    s/¤Æ/ t e/g;
    s/¤È/ t o/g;
    s/¤Ê/ n a/g;
    s/¤Ë/ n i/g;
    s/¤Ì/ n u/g;
    s/¤Í/ n e/g;
    s/¤Î/ n o/g;
    s/¤Ï/ h a/g;
    s/¤Ò/ h i/g;
    s/¤Õ/ f u/g;
    s/¤Ø/ h e/g;
    s/¤Û/ h o/g;
    s/¤Þ/ m a/g;
    s/¤ß/ m i/g;
    s/¤à/ m u/g;
    s/¤á/ m e/g;
    s/¤â/ m o/g;
    s/¤é/ r a/g;
    s/¤ê/ r i/g;
    s/¤ë/ r u/g;
    s/¤ì/ r e/g;
    s/¤í/ r o/g;
    s/¤¬/ g a/g;
    s/¤®/ g i/g;
    s/¤°/ g u/g;
    s/¤²/ g e/g;
    s/¤´/ g o/g;
    s/¤¶/ z a/g;
    s/¤¸/ j i/g;
    s/¤º/ z u/g;
    s/¤¼/ z e/g;
    s/¤¾/ z o/g;
    s/¤À/ d a/g;
    s/¤Â/ j i/g;
    s/¤Å/ z u/g;
    s/¤Ç/ d e/g;
    s/¤É/ d o/g;
    s/¤Ð/ b a/g;
    s/¤Ó/ b i/g;
    s/¤Ö/ b u/g;
    s/¤Ù/ b e/g;
    s/¤Ü/ b o/g;
    s/¤Ñ/ p a/g;
    s/¤Ô/ p i/g;
    s/¤×/ p u/g;
    s/¤Ú/ p e/g;
    s/¤Ý/ p o/g;
    s/¤ä/ y a/g;
    s/¤æ/ y u/g;
    s/¤è/ y o/g;
    s/¤ï/ w a/g;
    s/¤ð/ i/g;
    s/¤ñ/ e/g;
    s/¤ó/ N/g;
    s/¤Ã/ q/g;
    s/¡¼/:/g;

# ¤³¤³¤Þ¤Ç¤Ë½èÍý¤µ¤ì¤Æ¤Ê¤¤ ¤¡¤£¤¥¤§¤© ¤Ï¤½¤Î¤Þ¤ÞÂçÊ¸»ú°·¤¤
    s/¤¡/ a/g;
    s/¤£/ i/g;
    s/¤¥/ u/g;
    s/¤§/ e/g;
    s/¤©/ o/g;
    s/¤î/ w a/g;
    s/¤©/ o/g;

#¤½¤ÎÂ¾ÆÃÊÌ¤Ê¥ë¡¼¥ë
    s/¤ò/ o/g;

    s/^ ([a-z])/$1/g;
    s/:+/:/g;

    if (! /^[ a-zA-Z:]+$/) {
	print STDERR "$_\n";
    }

    print "$_\n";

}
