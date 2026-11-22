-- Q1: all events at a particular venue
SELECT e.event_id, e.title, e.category, e.start_time
FROM events e
JOIN venues v ON e.venue_id = v.venue_id
WHERE v.name = 'Crypto.com Arena'
ORDER BY e.start_time;

-- Q2: all tickets purchased by a particular user
SELECT o.order_id, o.order_date, e.title, t.name AS ticket_type, oi.quantity, oi.unit_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN ticket_types t ON oi.ticket_type_id = t.ticket_type_id
JOIN events e ON t.event_id = e.event_id
WHERE o.user_id = 3
ORDER BY o.order_date;

-- Q3: total tickets sold for each event
SELECT e.event_id, e.title, SUM(oi.quantity) AS tickets_sold
FROM events e
JOIN ticket_types t ON e.event_id = t.event_id
JOIN order_items oi ON t.ticket_type_id = oi.ticket_type_id
GROUP BY e.event_id, e.title
ORDER BY tickets_sold DESC;

-- Q4: remaining ticket inventory for an event
SELECT name, quantity_total, quantity_sold, quantity_total - quantity_sold AS remaining
FROM ticket_types
WHERE event_id = 6;

-- Q5: total revenue for each event
SELECT e.event_id, e.title, SUM(oi.quantity * oi.unit_price) AS revenue
FROM events e
JOIN ticket_types t ON e.event_id = t.event_id
JOIN order_items oi ON t.ticket_type_id = oi.ticket_type_id
GROUP BY e.event_id, e.title
ORDER BY revenue DESC;

-- Q6: customers who bought the most tickets
SELECT u.user_id, u.full_name, SUM(oi.quantity) AS total_tickets
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.full_name
ORDER BY total_tickets DESC
LIMIT 5;

-- Q7: events with sales over $3000
SELECT e.event_id, e.title, SUM(oi.quantity * oi.unit_price) AS revenue
FROM events e
JOIN ticket_types t ON e.event_id = t.event_id
JOIN order_items oi ON t.ticket_type_id = oi.ticket_type_id
GROUP BY e.event_id, e.title
HAVING SUM(oi.quantity * oi.unit_price) > 3000
ORDER BY revenue DESC;

-- Q8: monthly ticket revenue
SELECT DATE_TRUNC('month', payment_date) AS month, SUM(amount) AS revenue
FROM payments
WHERE status = 'succeeded'
GROUP BY month
ORDER BY month;
