window.onload = function(){
  document.getElementById('mark').addEventListener('click', addMarkup);
}

function addMarkup(){
  var textNode = document.getElementById("sentence").firstChild,
  selection="";
  if(window.getSelection){
    selection = window.getSelection().toString();
  }
  else if(document.selection && document.selection.type != "Control"){
    selection = document.selection.createRange().text;
  }
  if(selection.length === 0){
    return;
  }
  marked = "<mark>".concat(selection).concat("</mark>");
  result = textNode.nodeValue.replace(selection, marked);
  //alert(result);
  document.getElementById("sentenceMarkedUp").innerHTML= result;
}
