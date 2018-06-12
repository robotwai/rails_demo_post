// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree .
// = require jquery
//= require bootstrap

$(function(){

        $(".praise").click(function(){
            var a =$(this).attr("data-mid");
            var b =$(this).attr("data-uid");
            var c =$(this).attr("data-did");

            var praise = $("#a"+a);

            var praise_txt = $(praise).children(".praise-txt");
            var num=parseInt(praise_txt.text());

            var display =$(praise).children(".praise-img").css('display');
            if(display=="block"){
               
                $(praise).children(".praise-img-no").css('display','block');
                $(praise).children(".praise-img").css('display','none'); 
                num +=1;
                praise_txt.text(num)
                $.ajax({
                  type: 'POST',
                  url: "/dots",
                  data: {
                        micropost_id: a,
                        commenter_id: b
                  },
                  dataType: "json",
                  success: function(result){
                    
                      // alert("数据：" + JSON.parse(result.data).id);
                        praise.attr("data-did",JSON.parse(result.data).id);
                    }
                });

                // window.location.reload();
               
            }else{
                

                $(praise).children(".praise-img-no").css('display','none');
                $(praise).children(".praise-img").css('display','block'); 
               
                num -=1;
                praise_txt.text(num);

                 $.ajax({
                  type:"delete",
                  url: "/dots/"+c,
                  data: {
                        id: c,
                        
                  },
                  dataType: "json",
                  success: function(data,status){
                      // alert("数据：" + data + "\n状态：" + status);
                    },
                  error:function(xhr,textstatus,thrown){
                            alert("数据：" + textstatus + "\n状态：" + thrown);
                    }
                });
            }
        });

        $(".commit-img").click(function(){
            var a =$(this).attr("data-mid");
            var commit = $("#b"+a);
            
            var display =$(commit).children(".commit-list").css('display');
            if (display=="block") {
                $(commit).children(".commit-list").css('display','none');
            }else{

                $(commit).children(".commit-list").css('display','block');
            }
        });


    })
