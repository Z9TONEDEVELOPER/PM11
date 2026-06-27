// =====================================================
// БИЛЕТ 7 - Задание 3
// Концептуальная модель данных для dbdiagram.io
// =====================================================

// Таблица РЕГИОНЫ
Table Region {
  region_id int [pk, increment]
  region_name varchar(100) [not null]
  region_type varchar(50) [not null]
}

// Таблица ФИРМЫ (ПРОИЗВОДИТЕЛИ)
Table Manufacturer {
  manufacturer_id int [pk, increment]
  name varchar(200) [not null]
  address varchar(300)
  phone varchar(20)
}

// Таблица ТОВАРЫ
Table Product {
  product_id int [pk, increment]
  name varchar(200) [not null]
  sale_price decimal(10,2) [not null]
  purchase_price decimal(10,2) [not null]
  manufacturer_id int [not null]
  region_id int [not null]
}

// Связи между таблицами
Ref: Product.manufacturer_id > Manufacturer.manufacturer_id
Ref: Product.region_id > Region.region_id