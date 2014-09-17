#!/usr/bin/perl

print <<"VERBATIM";

<head>
<style type="text/css">
.parent {
position: relative;
}

body {
    font-family: "Trebuchet MS";
    font-size: 24;
  }
  h1, h2, h3 {
    font-family: 'Helvetica';
    font-weight: 400;
    font-size: 40;
    margin-bottom: -10px;
  }
  ul li {padding: 4px}
  ul li ul {padding: 2px; font-size: 20; margin-left: 26px}

.a {
position: absolute;
top: -10px;
height: 1200px;
z-index: 1;
background: white;
}

.b {
position: absolute;
height: 2400px;
width: 2400px;
z-index: 2;
background: white;
}

</style>
</head>

VERBATIM

$id=1;

while(<STDIN>) {
    if(/<hr \/>/) {
        if($id != 1) {
            print "</div>\n";
        }
        print "<div class=\"a\" id=\"$id\">\n";
        $id++;
    } else {
        print;
    }
}

print "</div> <div class=\"b\"> </div>\n";

print <<"VERBATIM";

<script>
document.onkeydown = checkKey;

active = 1;

sendToFront(active);

function checkKey(e) {
    e = e || window.event;

    if (e.keyCode == '39') { 
        if (document.getElementById(active+1) != null) {
            sendToBack(active);
            active = active + 1;
            sendToFront(active);
            scroll(0,0);
        }
        e.preventDefault();
    }
    if (e.keyCode == '37') {
        if (document.getElementById(active-1) != null) {
            sendToBack(active);
            active = active - 1;
            sendToFront(active);
            scroll(0,0);
        }
        e.preventDefault();
    }
}

function sendToFront(id) {
    var elem = document.getElementById(id);
    elem.style.zIndex = 3;
}

function sendToBack(id) {
    var elem = document.getElementById(id);
    elem.style.zIndex = 1;
}

</script>


VERBATIM
