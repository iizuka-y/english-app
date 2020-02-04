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
//= require tag-it
//= require bootstrap
//= require activestorage
//= require jquery.jscroll.min.js
//= require cropper.min.js
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
    minLength: 2,
    autoFocus: true,
    focus: function(event, ui){event.preventDefault()},
    select: function(event, ui) {
        $('#auto-complete').val(ui.item.value.replace(/\(\d+\D\)/g, ""));
        return false;
      }
  });

  //投稿のタグ
  $("#post-tags").tagit({
    fieldName:   'post[tag_list]',
    singleField: true,
    tagLimit: 3,
    allowSpaces: true,
    availableTags: gon.available_tags,
    autocomplete: {
      delay: 500,
      minLength: 2,
      autoFocus: true,
      focus: function(event, ui){event.preventDefault()}
    },
    preprocessTag: function(val) { // タグ選択時に（投稿回数）部分をreplace
      return val.replace(/\(\d+\D\)/g, "");
    }
 });
 if (gon.post_tags != null){
   //alert(gon.article_tags);
   for(tag in gon.post_tags){
     $('#post-tags').tagit('createTag', gon.post_tags[tag]);
   };
 };

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

// 投稿のモーダル
// alert("ok");
// モーダルを表示
$(document).on("click", ".post-option, .reibun-box, #edit-category", function(e) {
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
  // モーダルのスクロール固定を解除
  $('body').attr( { style: '' } );
  window.scrollTo( 0 , scrollPosition );
})

$(document).on('click','.modal',function(e){
  e.stopPropagation();
})


// モーダルを非表示
$(document).on("click", ".close-modal, .edit, .show-post", function(e) {
  $('.post-modal-wrapper').fadeOut();
  //モーダルのスクロール固定を解除
  $('body').attr( { style: '' } );
  window.scrollTo( 0 , scrollPosition );

});

// 例文帳登録用
$(document).on('change', '.category', function(){
	var select_val = $(this).val();
  //alert(select_val);
	if (select_val == "00"){
		$(this).next('.reibun-category-form').val("").show();
	}else{
		$(this).next('.reibun-category-form').val(select_val).hide();
	};
});

// submitに何故かつくdisabledを取り除く
/*
$(document).on('click','.reibun-form', function(){
  $(this).find('.select-submit').prop('disabled', false);
});
*/

// 例文帳のバリデーション
$(document).on('click', '.select-submit', function(e){
  if( $(this).prevAll('.reibun-category-form').val() == "" ){
    $(this).prevAll('.categoryMsg').html("カテゴリーを入力してください");
    e.preventDefault();
  }else if( $(this).prevAll('.reibun-category-form').val().length > 10 ){
    $(this).prevAll('.categoryMsg').html("文字数は10文字以内で入力してください");
    e.preventDefault();
  }else{
    $('.post-modal-wrapper').fadeOut();
    //モーダルのスクロール固定を解除
    $('body').attr( { style: '' } );
    window.scrollTo( 0 , scrollPosition );
  };
});

// 例文帳のカテゴリー選択
function dropsort() {
    var browser = $('#category').val();
    //alert(browser);
    location.href = browser;
}

// 例文帳編集用
$(document).on('change', '#category-edit', function(){
	var select_val = $(this).val();
  //alert(select_val);
	if (select_val == "00"){
		$(this).nextAll('.reibun-category-form').val("").hide();
    $('.reibun-category-form2').val("");
    $('.reibun-category-form3').val("");
    $('.category-h3-hidden').hide();
    $('.select-submit2').hide();
    $('.select-submit3').hide();
	}else{
		$(this).nextAll('.reibun-category-form').val(select_val).show();
    $('.reibun-category-form2').val(select_val);
    $('.reibun-category-form3').val(select_val);
    $('.category-h3-hidden').show();
    $('.select-submit2').show();
    $('.select-submit3').show();
	};
});

$(document).on('click', '.select-submit2', function(e){
  if( $('.reibun-category-form2').val() == "" ){
    $('.categoryMsg').html("カテゴリーを選択してください");
    e.preventDefault();
  }else{
    if(!confirm('カテゴリーを削除するとそのカテゴリーに属する投稿の登録が解除されます。よろしいですか？')){
        e.preventDefault();
    };
  };
});
