using Toybox.Application;
using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class App extends Application.AppBase {
    var name = "";
    var price = "";
    var isLoading = false;
    var error = null;

    function initialize() {
        System.println("=== APP INITIALIZE ===");
        AppBase.initialize();
        makeRequest();
    }

    function onStart(state) {
        System.println("=== APP START ===");
    }

    function onStop(state) {
        System.println("=== APP STOP ===");
    }

    function getInitialView() {
        System.println("=== GET INITIAL VIEW ===");
        return [new ProBeautySpaceView(), new ProBeautySpaceDelegate()];
    }

    function makeRequest() {
        System.println("🔄 MAKE REQUEST STARTED");
        isLoading = true;
        error = null;
        WatchUi.requestUpdate();

        var url = "https://api.npoint.io/eae3eb3e944cf7a94bc5";
        
        System.println("📡 URL: " + url);
        
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        try {
            Communications.makeWebRequest(
                url,
                {},
                options,
                new Method(self, :handleResponse)
            );
            System.println("✅ REQUEST SENT SUCCESSFULLY");
        } catch (e) {
            System.println("❌ EXCEPTION IN MAKE REQUEST: " + e.getErrorMessage());
            error = "Ошибка отправки: " + e.getErrorMessage();
            isLoading = false;
            WatchUi.requestUpdate();
        }
    }

    function handleResponse(responseCode, data) {
        System.println("=== HANDLE RESPONSE ===");
        System.println("📡 RESPONSE CODE: " + responseCode);
        System.println("📦 DATA TYPE: " + data);
        System.println("📦 DATA: " + data);
        
        isLoading = false;
        
        if (responseCode == 200) {
            System.println("✅ HTTP 200 - SUCCESS");
            if (data != null) {
                System.println("🔄 PROCESSING DATA...");
                processData(data);
            } else {
                error = "Нет данных";
                System.println("❌ DATA IS NULL");
            }
        } else if (responseCode == 404) {
            error = "Ошибка 404 - Не найдено";
            System.println("❌ HTTP 404 - NOT FOUND");
        } else if (responseCode == 500) {
            error = "Ошибка 500 - Сервер";
            System.println("❌ HTTP 500 - SERVER ERROR");
        } else if (responseCode == -1000) {
            error = "Нет сети";
            System.println("❌ ERROR -1000: NO NETWORK");
        } else if (responseCode == -400) {
            error = "Ошибка запроса";
            System.println("❌ ERROR -400: BAD REQUEST");
        } else {
            error = "Ошибка: " + responseCode.toString();
            System.println("❌ UNKNOWN ERROR CODE: " + responseCode);
        }
        
        System.println("🔄 UPDATING UI...");
        WatchUi.requestUpdate();
        System.println("=== END HANDLE RESPONSE ===");
    }

    function processData(data) {
        System.println("=== PROCESS DATA ===");
        try {
            System.println("🔧 DATA CLASS: " + data);
            
            if (data instanceof Array) {
                System.println("📋 DATA IS ARRAY, SIZE: " + data.size());
                if (data.size() > 0) {
                    var item = data[0];
                    System.println("📝 FIRST ITEM: " + item);
                    
                    if (item instanceof Dictionary) {
                        name = item["name"] != null ? item["name"].toString() : "";
                        price = item["price"] != null ? item["price"].toString() : "";
                        error = null;
                        System.println("✅ DATA PARSED SUCCESSFULLY");
                        System.println("🏷️ NAME: " + name);
                        System.println("💰 PRICE: " + price);
                    } else {
                        error = "Неверный формат элемента";
                        System.println("❌ ITEM IS NOT DICTIONARY");
                    }
                } else {
                    error = "Пустой массив";
                    System.println("❌ ARRAY IS EMPTY");
                }
            } else if (data instanceof Dictionary) {
                System.println("📋 DATA IS DICTIONARY");
                
                if (data["name"] != null) {
                    name = data["name"] != null ? data["name"].toString() : "";
                    price = data["price"] != null ? data["price"].toString() : "";
                    System.println("✅ YOUR API DATA PARSED");
                } else {
                    error = "Неверный формат данных";
                    System.println("❌ INVALID DATA FORMAT");
                }
                
                error = null;
                System.println("🏷️ NAME: " + name);
                System.println("💰 PRICE: " + price);
            } else {
                error = "Неизвестный формат данных";
                System.println("❌ UNKNOWN DATA TYPE");
            }
        } catch (e) {
            error = "Ошибка данных";
            System.println("💥 EXCEPTION IN PROCESS DATA: " + e.getErrorMessage());
        }
        System.println("=== END PROCESS DATA ===");
    }

    function getName() {
        return name;
    }

    function getPrice() {
        return price;
    }

    function getError() {
        return error;
    }

    function getIsLoading() {
        return isLoading;
    }
}

class ProBeautySpaceView extends WatchUi.View {
    function initialize() {
        System.println("=== VIEW INITIALIZE ===");
        View.initialize();
    }

    function onLayout(dc) {
        System.println("=== VIEW ON LAYOUT ===");
    }

    function onUpdate(dc) {
        System.println("=== VIEW ON UPDATE ===");
        
        var app = Application.getApp();
        System.println("🔄 APP STATE - Loading: " + app.getIsLoading() + ", Error: " + app.getError() + ", Name: " + app.getName() + ", Price: " + app.getPrice());
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        System.println("📏 SCREEN SIZE: " + width + "x" + height);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (app.getIsLoading()) {
            System.println("🔄 SHOWING LOADING...");
            drawWatchFace(dc, width, height, "Загрузка...", "");
        } else if (app.getError() != null) {
            System.println("❌ SHOWING ERROR: " + app.getError());
            drawWatchFace(dc, width, height, "Ошибка", app.getError());
        } else {
            System.println("✅ SHOWING DATA");
            drawWatchFace(dc, width, height, app.getName(), app.getPrice());
        }
        
        System.println("=== END VIEW UPDATE ===");
    }
    
    function drawWatchFace(dc, width, height, nameText, priceText) {
        System.println("🎨 DRAWING WATCH FACE - Name: '" + nameText + "', Price: '" + priceText + "'");
        
        var centerX = width / 2;
        
        // Получаем текущее время
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        System.println("⏰ TIME: " + timeString);
        
        // ВЫЧИСЛЯЕМ ВЫСОТЫ ШРИФТОВ
        var nameFont = findFittingFont(dc, nameText, width * 0.9, [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY]);
        var nameHeight = dc.getFontHeight(nameFont);
        
        var timeFont = Graphics.FONT_NUMBER_THAI_HOT;
        var timeHeight = dc.getFontHeight(timeFont);
        
        var priceFont = findFittingFont(dc, priceText, width * 0.9, [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY]);
        var priceHeight = dc.getFontHeight(priceFont);
        
        System.println("📏 FONT HEIGHTS - Name: " + nameHeight + ", Time: " + timeHeight + ", Price: " + priceHeight);
        
        // НАЗВАНИЕ - 5% от верха - высота_шрифта / 2
        var nameTopPosition = (height * 0.05).toNumber();
        var nameY = nameTopPosition - (nameHeight / 2);
        System.println("📛 NAME - 5% position: " + nameTopPosition + ", Final Y: " + nameY);
        dc.drawText(centerX, nameY, nameFont, nameText, Graphics.TEXT_JUSTIFY_CENTER);
        
        // ВРЕМЯ - 50% от верха - высота_шрифта / 2
        var timeTopPosition = (height * 0.5).toNumber();
        var timeY = timeTopPosition - (timeHeight / 2);
        System.println("⏰ TIME - 50% position: " + timeTopPosition + ", Final Y: " + timeY);
        dc.drawText(centerX, timeY, timeFont, timeString, Graphics.TEXT_JUSTIFY_CENTER);
        
        // ЦЕНА - 95% от верха - высота_шрифта / 2
        var priceTopPosition = (height * 0.95).toNumber();
        var priceY = priceTopPosition - (priceHeight / 2);
        System.println("💰 PRICE - 95% position: " + priceTopPosition + ", Final Y: " + priceY);
        dc.drawText(centerX, priceY, priceFont, priceText, Graphics.TEXT_JUSTIFY_CENTER);
        
        System.println("🎨 WATCH FACE DRAWN");
    }
    
    function findFittingFont(dc, text, maxWidth, fonts) {
        if (text == null || text.length() == 0) {
            return fonts[0];
        }
        
        System.println("🔍 FINDING FONT FOR: '" + text + "' (max width: " + maxWidth + ")");
        
        for (var i = 0; i < fonts.size(); i++) {
            var font = fonts[i];
            var textWidth = dc.getTextWidthInPixels(text, font);
            System.println("📏 FONT " + font + " WIDTH: " + textWidth);
            
            if (textWidth <= maxWidth) {
                System.println("✅ FOUND FITTING FONT: " + font);
                return font;
            }
        }
        
        System.println("⚠️ NO FITTING FONT, USING SMALLEST: " + fonts[fonts.size() - 1]);
        return fonts[fonts.size() - 1];
    }
}

class ProBeautySpaceDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        System.println("=== DELEGATE INITIALIZE ===");
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        System.println("🎯 SELECT BUTTON PRESSED");
        var app = Application.getApp();
        app.makeRequest();
        return true;
    }

    function onBack() {
        System.println("🎯 BACK BUTTON PRESSED");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}