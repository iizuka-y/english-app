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
//= require jquery
//= require jquery-ui
//= require bootstrap
//= require activestorage
//= require jquery.jscroll.min.js
//= require jquery.turbolinks
//= require turbolinks
//= require_tree .


$(document).on('turbolinks:load', function(){
  $fileField = $('#file')

  // 選択された画像を取得し表示
  $($fileField).on('change', $fileField, function(e) {
    //alert ("ok");
    file = e.target.files[0]
    reader = new FileReader(),
    $preview = $("#img-field");

    reader.onload = (function(file) {
      return function(e) {
        $preview.empty();
        $preview.append($('<img>').attr({
          src: e.target.result,
          class: "preview",
          title: file.name
        }));
        $('.field-image').append($('<div></div>').attr({
          class: "fa fa-times delete-preview"
        }));
        $('.remove_image').prop('checked', false);
      };
    })(file);
    reader.readAsDataURL(file); // 画像の読み込み
  });

  //無限スクロール
  $('.jscroll').jscroll({
    loadingHtml: '<img src="/assets/loading.gif" alt="Loading" class="loading"/> ',
    contentSelector: '.post-list',
    nextSelector: 'span.next:last a'
  });



  //オートコンプリート
  var data = ['test', 'have to', 'test2'];
  $('#auto-complete').autocomplete({
    source: "/posts/autocomplete.json",
    delay: 500,
    minLength: 2
  });

});

// 投稿画像消去
$(document).on('click', ".delete-preview", function(){
  //alert ("ok");
  $('.remove_image').prop('checked', true);
  $('#img-field').children('img').remove();
  $('#img-field').append($('<i class="fas fa-image"></i><i class="fas fa-file-upload add"></i>'));
  $('.delete-preview').remove();
  $('#file').val('');
});

//投稿のモーダル
//alert("ok");
//モーダルを表示
$(document).on("click", ".post-option", function(e) {
  //alert('モーダルを表示');
  scrollPosition = $(window).scrollTop();
  $(this).children('.post-modal-wrapper').fadeIn();
  // モーダルをスクロールできないように固定
  $('body').css('position','fixed')
           .css('width','100%')
           .css('height','100%')
           .css('left','0')
           .css({'top': -scrollPosition});

});

$(document).on('click','.post-modal-wrapper',function(e){
  e.stopPropagation();
  $('.post-modal-wrapper').fadeOut();
  //モーダルのスクロール固定を解除
  $('body').attr( { style: '' } );
  window.scrollTo( 0 , scrollPosition );
})

$(document).on('click','.modal',function(e){
  e.stopPropagation();
})


//モーダルを非表示
$(document).on("click", ".close-modal, .edit, .show-post", function(e) {
  $('.post-modal-wrapper').fadeOut();
  //モーダルのスクロール固定を解除
  $('body').attr( { style: '' } );
  window.scrollTo( 0 , scrollPosition );

});
