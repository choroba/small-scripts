#!/usr/bin/perl -w

=head1 txt file format

B<~> means unbreakable space. Use B<\~> to escape tilde.

B<Empty line> means new paragraph.

B<//> means line break.

B<"> are changed to lower and upper quotes. Similarly, B<'>,
B<E<lt>E<lt>> and B<E<gt>E<gt>>. B<'> can be escaped by B<\'>.

B<--> means m-dash.

B<{~n}> means n with tilde. You can use B<`'"v/^o> instead of B<~> to
mark grave, acute, umlaut, caron, slash, circumflex, ring.

B<\x> means the "times" sign.

B<$> means right-aligned paragraph. Use backslash to escape.

B<# at the beginning of a line> means a comment.

B<## and nothing else> means beginning of the comment section at
the end of the document.

B</>textB</> means text in italics. Use backslash to escape.

B<*>textB<*> means text in bold. Use backslash to escape.

B<^>textB<^> means superscript. Use backslash to escape.

B<_>textB<_> means section name. Use backslash to escape.

B<||> text B<||> means centered text.

B<==> text B<==> means title.

=cut

use open IN =>  ':encoding(iso-8859-2)';
binmode STDOUT, ':utf8';


print<<EOH;
% LaTeX
\\documentclass[11pt,a4paper]{article}
\\usepackage{polyglossia}
\\setmainlanguage{czech}
\\addtolength\\oddsidemargin{-2cm}
\\addtolength\\textwidth{4cm}
\\addtolength\\topmargin{-2cm}
\\addtolength\\textheight{4cm}
\\sloppy
\\begin{document}
EOH
@specials{'~','`',"'",'"','v','^','u'}=('~','`',"'",'"','v ','^','u ');
$line=join'',<>;
$line=~s:&:\\&:g;
$line=~s:<<:&laquo;:g;
$line=~s:>>:&raquo;:g;
$line=~s:\.{3}:\\dots{}:g;
$line=~s:\\~:&TILDE;:g;
$line=~s:\\':&APOSTROPHE;:g;
#$line=~s:~:&nbsp;:g;
#$line=~s:^$:<p>:gm;
$line=~s://:\\\\:g;
$line=~s:(?<!<!)--(?!>):---:g;
#$line=~s:(?<!{)"([^"]+)":\{\},,\{\}$1\{\}``\{\}:g;#quotedblbase,textquotedblleft
$line=~s:(?<!{)"([^"]+)":\\quotedblbase\{\}$1\\textquotedblleft\{\}:g;
$line=~s:'([^']+)':,$1\{\}`:g;#quotesinglbase,textquoteleft
#$line=~s:,,:&bdquo;:g;
#$line=~s:":&ldquo;:g;
$line=~s:\\\$:&dolar;:g;
$line=~s:<:\$<\$:g;#\textless
$line=~s:>:\$>\$:g;#\textgreater
$line=~s:&laquo;:<<:g;
$line=~s:&raquo;:>>:g;
$line=~s/^\$/\\hfill{}/gm;
$line=~s|^##$|\\framebox{\\parbox{\\textwidth}{|m and $div=1;
$line=~s|^#(.*?)$|\\framebox{$1}|gm;
$line=~s:\\/:&slash;:g;
$line=~s:\\\*:&ast;:g;
$line=~s:\\\^:&up;:g;
$line=~s:\\x:&times;:g;
$line=~s:\\_:&under;:g;
$line=~s:(?<![<{])/([^/]+)(?<![<{])/:\\textit{$1}:g;
$line=~s:\*([^*]+)\*:\\textbf{$1}:g;
$line=~s:\^([^^]+)\^:\$^{\\hbox{$1}}\$:g;
$line=~s:_([^_]+)_:\\subsection*{$1}:g;
$line=~s:==(.+?)==:\\section*{$1}:g;
$line=~s:\|\|([^|]+?)\|\|:\\begin{center}\n$1\n\\end{center}:g;
$line=~s:&TILDE;:\\~{ }:g;
$line=~s:&APOSTROPHE;:':g;
$line=~s:&dolar;:\\\$:g;
$line=~s:&slash;:/:g;
$line=~s:&ast;:*:g;
$line=~s:&up;:\$\\hat{~}\$:g;
$line=~s:&under;:\\_:g;
$line=~s:&times;:\$\\times\$:g;
$line=~s:{\\[oO]}:\\$1:g;
$line=~s:{o(([Aa]))}:\\$1$1:g;
$line=~s:{(.)(.)}:\\$specials{$1}$2:g;
print$line;
print '}}' if $div;
print"\\end{document}";
