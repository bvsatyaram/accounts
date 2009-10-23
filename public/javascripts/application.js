// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function myGroups(){
  if($("my_groups_link")){
    $("my_groups_link").observe('mouseover', function() {
      $("my_groups").show();
    });
    $("my_groups_link").observe('mouseout', function() {
      $("my_groups").hide();
    });
  }
}

var CommonItem = {
  elements: [],

  tType: function(){
    return $('common_item_transaction_type').value
  },

  typeChange: function(url){
    var url_with_params = url + '?type=' + this.tType();
    $('loading_image').show();
    new Ajax.Request(url_with_params, {asynchronous:true, evalScripts:true, method:'get'});
    return false;
  },

  observeAll: function(){
    for(i =0 ; i < this.elements.length; i++){
    Event.observe(this.elements[i], 'keyup',   function(){CommonItem.update_cost();}, false);
    Event.observe(this.elements[i], 'keydown', function(){CommonItem.update_cost();}, false);
    Event.observe(this.elements[i], 'click',   function(){CommonItem.update_cost();}, false);
    Event.observe(this.elements[i], 'blur', function(){CommonItem.update_cost();}, false);
    }
  },

  update_cost: function(){
    $('common_item_cost').disabled = false;
    $('common_item_cost').value = 0;
    var sum = 0;
    for(i =0 ; i < this.elements.length; i++){
      sum += parseInt(this.elements[i].value || 0);
    }
    $('common_item_cost').value = sum;

    if(this.tType() != "0"){
      $('common_item_cost').disabled = true;
    }
  },

  update_final_cost: function (){
    this.update_cost();

    if(isNaN($('common_item_cost').value)){
      alert("Give valid values for the items");
      return false;
    }
    $('common_item_cost').disabled = false;
    return true;
  },

  beforeSubmit: function(){
    if($('common_item_name').value == ""){
      alert("Forgot the name?? Give the name of the item");
      return false;
    }
    
    var theForm = document.getElementById('new_common_item');
    if(this.tType() == "0"){
      var z = 0;
      var count = 0;
      
      for (z = 0; z < theForm.length; z++) {
        if ((theForm[z].type == 'checkbox') && (theForm[z].checked)) {
          count += 1;
        }
      }
      if(count == 0){
        alert("Please select atleast one user!");
        return false;
      }
    }else{
      $('common_item_cost').disabled = false;
      return this.update_final_cost();
    }
  },

  selectAll: function(state){
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
}