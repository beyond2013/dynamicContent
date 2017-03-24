A small shiny app for annotating text files. 

1. The UI provides fileInput to select .txt files. sample files are under data/ within the repo. One of the files is the default when the app is launched.
2. Next, Previous buttons allow user to display the contents of the file, one sentence at a time.
3. User may select any text within a sentence and click the 'Add Markup' button to annotate the sentence. The Action Button triggers javascript function 'addMarkup()'. See www/textselection.js for details.
4. The sentence is displayed after being marked up. 
