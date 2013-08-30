#!/bin/bash

TMPDIR=/tmp/telalogon

mkdir -p "$TMPDIR"
chmod 700 "$TMPDIR"

cp $dirLib/*.jpg "$TMPDIR"/

######################################
funcUsu() {
	local ar=$TMPDIR/TOGGLE_$USU
	if test -e $ar; then
		cat $ar > $TMPDIR/TOGGLE
		echo "xusu=$USU"
		mostraAt
	fi
};export -f funcUsu
######################################
mostraAt() {
	local a=$(cat $TMPDIR/TOGGLE)
	ln -sf "$TMPDIR"/$a.jpg "$TMPDIR"/toggle.jpg
	echo "sess=\"$a\""
};export -f mostraAt
######################################
mudaImagem() {
	#echo "ii"
	local a=$(cat $TMPDIR/TOGGLE)
	a=$[a+1]
	if ! test -e $TMPDIR/$a.jpg; then
		a=0
	fi
	echo $a > "$TMPDIR"/TOGGLE
	mostraAt
}; export -f mudaImagem
######################################
telaInit() {
if [ ! -f "$TMPDIR"/TOGGLE ]; then echo 0 > "$TMPDIR"/TOGGLE; mudaImagem; fi
mostraAt
}

#tamanho da tela
x=$(xdpyinfo -display $DISPLAY|grep dimensions:|awk '{print $2}')
tx=800
ty=600
if [ "$(echo $x|grep x)" != "" ]; then
	tx=$(echo $x|cut -d 'x' -f 1)
	ty=$(echo $x|cut -d 'x' -f 2)
fi

export MAIN_DIALOG="
<window width-request=\"$tx\"  height-request=\"$ty\" title=\"${title}\" opacity=\"0.80000000596046448\" icon-name=\"gtk-preferences\" resizable=\"false\" decorated=\"${deco}\" ${WINPLACE}>

<vbox>
  <text label=\"\" ypad=\"60%\"></text>
<hbox>
  <text label=\"\" xpad=\"150%\"></text>



<vbox ypad=\"10\" xpad=\"20\">
  <text label=\"\" xalign=\"2\"></text>
  <text use-markup=\"true\" label=\"<b>Bem vindo!</b>\" xalign=\"2\"></text>
  <text label=\"\" xalign=\"2\"></text>
  <hbox>
   <vbox>
   <text height-request=\"35\" width_chars=\"6\" xalign=\"1\"><label>usuário</label></text>
   <text height-request=\"5\" label=\"\"></text>
   <text height-request=\"35\" width_chars=\"6\" xalign=\"1\"><label>senha</label></text>
   </vbox>
   <text label=\"\" xalign=\"2\"></text>
   <vbox>
   <entry height-request=\"35\" width_chars=\"15\"><variable>USU</variable><action signal=\"changed\">funcUsu</action><action type=\"refresh\">TOGGLEME</action>$uu</entry>
   <text height-request=\"5\" label=\"\"></text>
   <entry height-request=\"35\" width_chars=\"15\"><variable>PASS</variable><visible>password</visible></entry>
   </vbox>
  </hbox>
  <text label=\"\" xalign=\"2\"></text>
  <hbox>

   			<button>
				<variable>TOGGLEME</variable>
				<input file>$TMPDIR/toggle.jpg</input>
				<width>64</width>
				<action>mudaImagem</action>
				<action type=\"refresh\">TOGGLEME</action>
			</button>
    <text width_chars=\"0.2\" label=\"\"></text>
    <button use-stock=\"true\"><label>entrar</label></button>
    <text width_chars=\"0.2\" label=\"\"></text>
    <vbox>
    <button><label>desligar</label></button>
    <button><label>reiniciar</label></button>
    </vbox>
  </hbox>
  <text label=\"$msg\" xalign=\"2\"></text>
</vbox>

<text width_chars=\"4\" label=\"\" xalign=\"2\"></text>


  <text label=\"\" xpad=\"150%\"></text>
</hbox>
  <text label=\"\" ypad=\"50%\"></text>
</vbox>



</window>" 

dlg=gtkdialog
xx=$(telaInit;$dlg -c)
