// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import { I18n } from "i18n-js";

const i18n = new I18n({
        en: {
          calories: "kcal",
          gramm: "g",
          empty_cart_msg: "Your cart is empty..."
        },
        ru: {
          calories: "ккал",
          gramm: "г",
          empty_cart_msg: "Ваша корзина пуста..."
        },
      });

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
                emptyCartMsg.innerText = i18n.t('empty_cart_msg')
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
                                        <div class="d-inline-block me-2 my-3">${dish.calories} ${i18n.t('calories')}</div>
                                        <div class="d-inline-block my-2">${dish.weight} ${i18n.t('gramm')}</div>
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
                console.log(xrs.currentTarget.action)
                console.log(xrs.detail[0])
                console.log(data)
                console.log(status)
                render_cart(xrs.detail[0]);
        })
}
