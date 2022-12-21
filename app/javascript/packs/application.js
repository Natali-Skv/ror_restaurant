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


$(document).on('turbolinks:load', function () {
        $(".menu-link>span").on('click', function (event) {
                console.log(event.target.getAttribute("link"))
                $('html, body').animate({
                        scrollTop: $(`#${event.target.getAttribute("link")}`).offset().top - 140
                }, 5);
        });

        if (document.getElementById('cart')) {
                $.ajax({
                        url: "menu/cart",
                        context: document.body,
                        success: function (xrs) {
                                render_cart(xrs);
                        }
                });
        }

        $('form.button_to').on("ajax:success", function (xrs, data, status) {
                render_cart(xrs.detail[0]);
        })
});


function render_cart(data) {
        $('#cart').empty();
        let cart = document.getElementById("cart");
        let cartUl = document.createElement('ul');
        cartUl.className = "nav nav-pills flex-column mb-auto"
        cart.appendChild(cartUl)

        data.dishes.forEach(function (dish) {
                let dishLi = document.createElement('li')
                dishLi.innerHTML = `
                <div class="p-2 dish-in-cart">
                        <img class="ms-1 d-inline-block mb-3 cart-dish-img" src="/dishes/${dish.image_path}">
                                <div class="ms-1 d-inline-block mb-3 align-top">
                                        <p class="h5">${dish.name}</p>
                                        <div class="d-inline-block me-2 my-3">${dish.calories} ккал</div>
                                        <div class="d-inline-block my-2">${dish.weight} г</div>
                                <div>
                                        <button class="upd-cart change-count-btn _btn-primary" type="submit">+</button>
                                        <button class="upd-cart change-count-btn _btn-primary" type="submit">-</button>
                                        <div class="d-inline ms-5 h5">${dish.price} ₽</div>
                                </div>
                        </div>
                </div>
                `
                cartUl.appendChild(dishLi)
        });
        let totalElem = document.getElementById('total-price')
        totalElem.innerText = data.total
}
