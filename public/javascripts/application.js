// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var CommonItem = {
  elements: [],

  update_cost: function(){
    $('common_item_cost').disabled = false;
    $('common_item_cost').value = 0;
    var sum = 0;
    for(i =0 ; i < this.elements.length; i++){
      sum += parseInt(this.elements[i].value || 0);
    }
    $('common_item_cost').value = sum
    $('common_item_cost').disabled = true;
  },

  update_final_cost: function (){
    this.update_cost();

    if($('common_item_name').value == ""){
      alert("Forgot the name?? Give the name of the item");
      return false;
    }
    if(isNaN($('common_item_cost').value)){
      alert("Give valid values for the items");
      return false;
    }
    $('common_item_cost').disabled = false;
    return true;
  }
}

function selectAll(state){
    var theForm = document.getElementById('new_common_item');
	var z = 0;
    for (z = 0; z < theForm.length; z++) {
        if (theForm[z].type == 'checkbox') {
			theForm[z].checked = state;
		}
    }
    $('select').toggle();
    $('unselect').toggle();
}