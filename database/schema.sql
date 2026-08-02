CREATE TABLE category (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE customer (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(70) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    registration_date DATE NOT NULL
);

CREATE TABLE department (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employee (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(70) NOT NULL,
    department_id INTEGER NOT NULL,
    position VARCHAR(70) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,

    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id)
        REFERENCES department(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE supplier (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(70) NOT NULL,
    address VARCHAR(100) NOT NULL,
    bank_account VARCHAR(30) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE warehouse (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    address VARCHAR(100) NOT NULL
);

CREATE TABLE product (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INTEGER NOT NULL,
    article VARCHAR(20) NOT NULL UNIQUE,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES category(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE product_price (
    product_id INTEGER PRIMARY KEY,
    price NUMERIC(10,2) NOT NULL,

    CONSTRAINT chk_price
        CHECK (price > 0),

    CONSTRAINT fk_price_product
        FOREIGN KEY (product_id)
        REFERENCES product(id)
        ON DELETE CASCADE
);

CREATE TABLE stock (
    warehouse_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,

    PRIMARY KEY (warehouse_id, product_id),

    CONSTRAINT chk_quantity
        CHECK (quantity >= 0),

    CONSTRAINT fk_stock_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouse(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_stock_product
        FOREIGN KEY (product_id)
        REFERENCES product(id)
        ON DELETE CASCADE
);

CREATE TABLE supplier_product (
    supplier_id INTEGER,
    product_id INTEGER,

    PRIMARY KEY (supplier_id, product_id),

    CONSTRAINT fk_supplier_product_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES supplier(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_supplier_product_product
        FOREIGN KEY (product_id)
        REFERENCES product(id)
        ON DELETE CASCADE
);

CREATE TABLE orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,

    CONSTRAINT chk_order_status
        CHECK (
            order_status IN (
                'создан',
                'оплачен',
                'выдан',
                'отменен'
            )
        ),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN (
                'наличные',
                'карта',
                'онлайн',
                'не оплачен'
            )
        ),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_employee
        FOREIGN KEY (employee_id)
        REFERENCES employee(id)
        ON DELETE RESTRICT
);

CREATE TABLE order_items (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,

    CONSTRAINT chk_order_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_item_price
        CHECK (price > 0),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES product(id)
        ON DELETE RESTRICT
);

CREATE INDEX idx_product_category
ON product(category_id);

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_employee
ON orders(employee_id);

CREATE INDEX idx_order_items_order
ON order_items(order_id);

CREATE INDEX idx_stock_product
ON stock(product_id);

CREATE INDEX idx_supplier_product_product
ON supplier_product(product_id);