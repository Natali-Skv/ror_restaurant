// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


$(function () {
        $(".menu-link>span").on('click', function (event) {
                console.log(event.target.getAttribute("link"))
                $('html, body').animate({
                        scrollTop: $(`#${event.target.getAttribute("link")}`).offset().top - 140
                }, 5);
        });
        $('#phone').on('keydown', function (e) {
                inputphone(e, document.querySelector('#phone'))
        })
});

// на все кнопки "добавить в корзину вешается функция, которая либо отрисовывает модалку с логином, либо делает запрос на добавление товара в корзину"
// $(function () {
//         $(".add-btn").on('click',function () {
//                 $("#login-modal").modal();
//         });
// });


//-- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --


//Функция маски формат +7 (
function inputphone(e, phone) {
        function stop(evt) {
                evt.preventDefault();
        }
        let key = e.key, v = phone.value; not = key.replace(/([0-9])/, 1)

        if (not == 1 || 'Backspace' === not) {
                if ('Backspace' != not) {
                        if (v.length < 3 || v === '') { phone.value = '+7(' }
                        if (v.length === 6) { phone.value = v + ')' }
                        if (v.length === 10) { phone.value = v + '-' }
                        if (v.length === 13) { phone.value = v + '-' }
                }
        } else { stop(e) }
}
