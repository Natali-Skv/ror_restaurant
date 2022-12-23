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
        $("#radio-ru,#radio-en").on('click', function (e) {
                window.location = `${window.location.pathname}?locale=${e.target.getAttribute("lang")}`;
        })
        $(".menu-link>span").on('click', function (event) {
                console.log(event.target.getAttribute("link"))
                $('html, body').animate({
                        scrollTop: $(`#${event.target.getAttribute("link")}`).offset().top - 140
                }, 5);
        });

        if (document.getElementById('cart')) {
                $.ajax({
                        url: "/menu/cart",
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

        if (!data.dishes || !data.dishes.length) {
                let emptyCartMsg = document.createElement('li')
                emptyCartMsg.innerText = 'Ваша корзина пуста...'
                emptyCartMsg.className = 'mt-3 h4'
                cartUl.appendChild(emptyCartMsg)
                let totalElem = document.getElementById('total-price')
                totalElem.innerText = 0
                return
        }

        data.dishes.forEach(function (dish) {
                let dishLi = document.createElement('li')
                dishLi.innerHTML = `
                <div class="m-2 p-2 dish-in-cart">
                        <img class="ms-1 d-inline-block mb-3 cart-dish-img" src="/dishes/${dish.image_path}">
                                <div class="dish-in-cart-info ms-1 d-inline-block mb-3 align-top">
                                        <p class="h5">${dish.name}</p>
                                        <div class="d-inline-block me-2 my-3">${dish.calories} ккал</div>
                                        <div class="d-inline-block my-2">${dish.weight} г</div>
                                <div>
                                <form class="button_to d-inline" method="post" action="/menu/remove_dish/${dish.id}.json" data-remote="true">
                                        <input class="upd-cart changse-count-btn _btn-primary" type="submit" value="-">
                                </form>
                                        <div class="d-inline mx-2 h5">${dish.count}</div>
                                <form class="button_to d-inline" method="post" action="/menu/add_dish/${dish.id}.json" data-remote="true">
                                        <input class="upd-cart changse-count-btn _btn-primary" type="submit" value="+">
                                </form>
                                        <div class="d-inline float-end h5">${dish.price} ₽</div>
                                </div>
                        </div>
                </div>
                `
                cartUl.appendChild(dishLi)
        });
        let totalElem = document.getElementById('total-price')
        totalElem.innerText = data.total
        $('form.button_to').on("ajax:success", function (xrs, data, status) {
                render_cart(xrs.detail[0]);
        })
}

{/* <form class="button_to" method="post" action="http://localhost:3000/menu/add_dish/616.json" data-remote="true">
        <input class="upd-cart mb-3 add-btn _btn-primary" type="submit" value="Добавить">
                <input type="hidden" name="authenticity_token" value="xIfQdMSutcTRThfNJ0iVV2deNsWvOi3foDchTk_bFE7iCnH5J19whcUA582U8BiF114KSpd6cB2D6oa-RZdLYw" autocomplete="off">
</form> */}

// <button class="upd-cart changse-count-btn _btn-primary" type="submit">+</button>
