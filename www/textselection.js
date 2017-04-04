window.onload = function(){
  document.getElementById('mark').addEventListener('click', addMarkup);
}

function addMarkup(){
  var sentence = document.getElementById("sentence").innerHTML,
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
  result = sentence.replace(selection, marked);
  document.getElementById("sentence").innerHTML = result;
  Shiny.onInputChange("textresult",result);
}
