CREATE TABLE users (
    user_id     SERIAL PRIMARY KEY,
    email       VARCHAR(100) NOT NULL UNIQUE,
    full_name   VARCHAR(100) NOT NULL,
    role        VARCHAR(20)  NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'admin')),
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE venues (
    venue_id  SERIAL PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    address   VARCHAR(200) NOT NULL,
    city      VARCHAR(50)  NOT NULL,
    capacity  INT          NOT NULL CHECK (capacity > 0)
);

CREATE TABLE events (
    event_id    SERIAL PRIMARY KEY,
    venue_id    INT          NOT NULL REFERENCES venues(venue_id),
    title       VARCHAR(150) NOT NULL,
    category    VARCHAR(30)  NOT NULL,
    start_time  TIMESTAMP    NOT NULL,
    end_time    TIMESTAMP    NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'scheduled'
);

CREATE TABLE ticket_types (
    ticket_type_id  SERIAL PRIMARY KEY,
    event_id        INT           NOT NULL REFERENCES events(event_id),
    name            VARCHAR(50)   NOT NULL,
    price           DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    quantity_total  INT           NOT NULL CHECK (quantity_total > 0),
    quantity_sold   INT           NOT NULL DEFAULT 0,
    CHECK (quantity_sold <= quantity_total)
);

CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    user_id       INT           NOT NULL REFERENCES users(user_id),
    order_date    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount  DECIMAL(10,2) NOT NULL,
    status        VARCHAR(20)   NOT NULL DEFAULT 'paid'
);

CREATE TABLE order_items (
    order_item_id   SERIAL PRIMARY KEY,
    order_id        INT           NOT NULL REFERENCES orders(order_id),
    ticket_type_id  INT           NOT NULL REFERENCES ticket_types(ticket_type_id),
    quantity        INT           NOT NULL CHECK (quantity > 0),
    unit_price      DECIMAL(10,2) NOT NULL
);

CREATE TABLE payments (
    payment_id    SERIAL PRIMARY KEY,
    order_id      INT           NOT NULL UNIQUE REFERENCES orders(order_id),
    amount        DECIMAL(10,2) NOT NULL,
    method        VARCHAR(20)   NOT NULL,
    status        VARCHAR(20)   NOT NULL,
    payment_date  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_events_venue ON events(venue_id);
CREATE INDEX idx_ticket_types_event ON ticket_types(event_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_ticket_type ON order_items(ticket_type_id);
CREATE INDEX idx_payments_date ON payments(payment_date);
