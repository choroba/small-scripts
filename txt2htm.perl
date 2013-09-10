#!/usr/bin/perl -w
# -*- cperl -*-

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

B<[[>textB<]]> means footnote.

=cut



print<<EOH;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><title></title><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2"><style type="text/css"><!-- *{font-size:11pt;font-family:times new roman,serif;} p{margin:0 0 0 0;text-align:justify;text-indent:1cm;} h2{font-size:12pt;} --></style></head><body text=black bgcolor=white>
EOH
@specials{'~','`',"'",'"','v','/','^','o'}=qw/tilde grave acute uml caron slash circ ring/;
$line=join'',<>;
$line=~s:&:&amp;:g;
$line=~s:<<:&laquo;:g;
$line=~s:>>:&raquo;:g;
$line=~s:<:&lt;:g;
$line=~s:>:&gt;:g;
$line=~s:\.{3}:&hellip;:g;
$line=~s:{(.)(.)}:&$2$specials{$1};:g;
$line=~s:\\~:&TILDE;:g;
$line=~s:\\':&APOSTROPHE;:g;
$line=~s:~:&nbsp;:g;
$line=~s:^$:<p>:gm;
$line=~s://:<br>:g;
$line=~s:(?<!<!)--(?!>):&mdash;:g;
$line=~s:"([^"]+)":&bdquo;$1&ldquo;:g;
$line=~s:'([^']+)':&sbquo;$1&lsquo;:g;
#$line=~s:,,:&bdquo;:g;
#$line=~s:":&ldquo;:g;
$line=~s:\\\$:&dolar;:g;
$line=~s/^\$/<p style="text-align:right;padding-top:10pt">/gm;
$line=~s|^##$|<hr><div style=color:gray>|m and $div=1;
$line=~s|^#(.*?)$|<div style="padding:10pt 10pt 10pt 10pt;color:gray;">$1</div>|gm;
$line=~s:\\/:&slash;:g;
$line=~s:\\\*:&ast;:g;
$line=~s:\\\^:&up;:g;
$line=~s:\\x:&times;:g;
$line=~s:\\_:&under;:g;
$line=~s:(?<!<)/([^/]+)(?<!<)/:<i>$1</i>:g;
$line=~s:\*([^*]+)\*:<b>$1</b>:g;
$line=~s:\^([^^]+)\^:<sup>$1</sup>:g;
$line=~s:_([^_]+)_:<h3>$1</h3>:g;
$line=~s:==(.+?)==:<h2>$1</h2>:gs;
$line=~s:\|\|(.+?)\|\|:<center>$1</center>:gs;
$line=~s!\[\[(.+?)\]\]!push @footnotes, $1; $f=@footnotes; qq{<sup><a name="a-$f" href="#f-$f" style="font-size:70%">$f</a></sup>}!ges;
$line=~s:&TILDE;:~:g;
$line=~s:&APOSTROPHE;:&rsquo;:g;
$line=~s:&dolar;:\$:g;
$line=~s:&slash;:/:g;
$line=~s:&ast;:*:g;
$line=~s:&up;:^:g;
$line=~s:&under;:_:g;
print $line;
print '</div>' if $div;
if (@footnotes) {
    print '<hr>';
    print qq{<p><sup><a name="f-$_" href="#a-$_" style="font-size:70%">},$_,'</a></sup> ',$footnotes[$_-1],'</p>' for 1 .. @footnotes;
}
print"</body></html>";
