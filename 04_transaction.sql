-- Purchase: Carla (user 3) buys 2 General tickets for Drake (ticket type 1)
BEGIN;

INSERT INTO orders (user_id, total_amount, status)
VALUES (3, 300.00, 'paid');

INSERT INTO order_items (order_id, ticket_type_id, quantity, unit_price)
VALUES (currval('orders_order_id_seq'), 1, 2, 150.00);

UPDATE ticket_types
SET quantity_sold = quantity_sold + 2
WHERE ticket_type_id = 1;

INSERT INTO payments (order_id, amount, method, status)
VALUES (currval('orders_order_id_seq'), 300.00, 'card', 'succeeded');

COMMIT;


-- Failed purchase: Dev (user 4) tries to buy 5 Doja Cat Meet & Greet tickets (ticket type 12),
-- but only 1 is left. The UPDATE breaks the CHECK constraint, so we ROLLBACK and nothing is saved.
BEGIN;

INSERT INTO orders (user_id, total_amount, status)
VALUES (4, 2000.00, 'paid');

INSERT INTO order_items (order_id, ticket_type_id, quantity, unit_price)
VALUES (currval('orders_order_id_seq'), 12, 5, 400.00);

UPDATE ticket_types
SET quantity_sold = quantity_sold + 5
WHERE ticket_type_id = 12;

INSERT INTO payments (order_id, amount, method, status)
VALUES (currval('orders_order_id_seq'), 2000.00, 'card', 'succeeded');

COMMIT;
