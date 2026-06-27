<?php
// Функция преобразования Фаренгейт -> Цельсий
function fahrenheitToCelsius($f) {
    return ($f - 32) * 5 / 9;
}

// Функция преобразования Цельсий -> Фаренгейт
function celsiusToFahrenheit($c) {
    return $c * 9 / 5 + 32;
}

// Тестовые данные
$temperaturesF = [32, 50, 68, 86, 100, 212];
$temperaturesC = [0, 10, 20, 30, 37, 100];

echo "=== Преобразование Фаренгейт -> Цельсий ===\n";
foreach ($temperaturesF as $f) {
    $c = fahrenheitToCelsius($f);
    echo "$f°F = " . round($c, 2) . "°C\n";
}

echo "\n=== Преобразование Цельсий -> Фаренгейт ===\n";
foreach ($temperaturesC as $c) {
    $f = celsiusToFahrenheit($c);
    echo "$c°C = " . round($f, 2) . "°F\n";
}
?>