######################################################
##################      Task 1      ##################
######################################################

scores = [75, 90, 60, 85, 90, 50, 75, 95]
unique_scores = sorted(set(scores), reverse=True)
scores_70_or_more = [score for score in scores if score >= 70]
second_highest = unique_scores[1]
average_score = sum(scores) / len(scores) if scores else 0
adjusted_scores = [score if score >= 60 else 60 for score in scores]
score_frequency = {score: scores.count(score) for score in set(scores)}

print("Original scores:", scores)
print("Unique scores (descending):", unique_scores)
print("Scores >= 70:", scores_70_or_more)
print("Second-highest distinct score:", second_highest)
print("Average:", average_score)
print("Adjusted scores:", adjusted_scores)
print("Score frequencies:", score_frequency)

#6-
#- `list.sort()` sorts a list **in place**, so it changes the original list and returns `None`.
#- `sorted(iterable)` returns a **new sorted list** and leaves the original iterable unchanged.





######################################################
##################      Task 2      ##################
######################################################

python_students = {"Ahmed", "Sara", "Omar", "Mona"}
sql_students = {"Sara", "Mona", "Ali", "Youssef"}
both_courses = python_students & sql_students
either_course = python_students | sql_students
exactly_one_course = python_students ^ sql_students
python_only = python_students - sql_students
sql_only = sql_students - python_students
all_sql_in_python = sql_students.issubset(python_students)

print("Both courses:", sorted(both_courses))
print("Either course:", sorted(either_course))
print("Exactly one course:", sorted(exactly_one_course))
print("Python only:", sorted(python_only))
print("SQL only:", sorted(sql_only))
print("Every SQL student is in Python:", all_sql_in_python)

python_students.add("Nour")
sql_students.discard("Ali")

all_updated_students = python_students | sql_students
print("Updated Python students:", sorted(python_students))
print("Updated SQL students:", sorted(sql_students))
print("Total distinct students after updates:", len(all_updated_students))




######################################################
##################      Task 3      ##################
######################################################

sales = {"Laptop": 25000, "Mouse": 500, "Keyboard": 1200, "Monitor": 7000}

sales["Headphones"] = 1800
sales["Mouse"] = 650

total_sales = sum(sales.values())
highest_product = max(sales, key=sales.get)

high_sales_products = {product: amount for product, amount in sales.items() if amount > 1500}

printer_sales = sales.get("Printer", 0)

products_by_sales = sorted(sales, key=sales.get, reverse=True)

sales_percentages = {
    product: (amount / total_sales) * 100
    for product, amount in sales.items()
                      }

print("Updated sales:", sales)
print("Total sales:", total_sales)
print("Highest-sales product:", highest_product, "=", sales[highest_product])
print("Products with sales > 1500:", high_sales_products)
print("Printer sales (safe lookup):", printer_sales)
print("Products sorted by sales:", products_by_sales)
print("Sales percentages:", {name: round(pct, 2) for name, pct in sales_percentages.items()})




######################################################
##################      Task 4      ##################
######################################################

def calculate_average(scores):
    if not scores:
        return 0
    return sum(scores) / len(scores)


def get_result(score, passing_score=60):
    return "Pass" if score >= passing_score else "Fail"


def summarize_student(name, scores):
    average = calculate_average(scores)
    result = get_result(average) 
    return {
        "name": name,
        "average_score": average,
        "result": result
    }


print("Empty average:", calculate_average([]))
print("Average exactly 60:", summarize_student("Test 60", [60]))
print("Custom passing score 70:", get_result(69, passing_score=70))
print("Custom threshold, score 70:", get_result(70, passing_score=70))

positional_summary = summarize_student("Ahmed", [80, 70, 90])
keyword_summary = summarize_student(name="Sara", scores=[60, 70, 80])

print("Positional call:", positional_summary)
print("Keyword call:", keyword_summary)


def count_results(summaries):
    counts = {"passing": 0, "failing": 0}
    for summary in summaries:
        if summary["result"] == "Pass":
            counts["passing"] += 1
        else:
            counts["failing"] += 1
    return counts


print("Counts for two summaries:", count_results([positional_summary, keyword_summary]))
print("Counts for empty list:", count_results([]))




######################################################
##################      Task 5      ##################
######################################################

students = [
            {"name": "Ahmed", "scores": [80, 75, 90]},
            {"name": "Sara", "scores": [95, 88, 92]},
            {"name": "Omar", "scores": [45, 60, 50]},
            {"name": "Mona", "scores": [70, 65, 75]}  
            ]

summaries = [
                summarize_student(student["name"], student["scores"])
                for student in students
            ]

ranked_summaries = sorted(
                            summaries,
                            key=lambda student: student["average_score"],
                            reverse=True
                            )

passing_students = list(
                         filter(lambda student: student["result"] == "Pass", ranked_summaries)
                       )

passing_names = list(
                       map(lambda student: student["name"], passing_students)
                     )

for student in ranked_summaries:
    print(
        f'{student["name"]}: {student["average_score"]:.2f} — {student["result"]}'
         )


print("Passing names:", passing_names)
print("Result counts:", count_results(summaries))

alphabetical_summaries = sorted(summaries, key=lambda student: student["name"])
print("Alphabetical order:", [student["name"] for student in alphabetical_summaries])




######################################################
##################      Task 6      ##################
######################################################

## Task 6 — Explain Your Choices

#**1. Why is a set suitable for removing duplicates, and what happens to ordering?**

#A set stores distinct values, so repeated values appear only once. A set does not preserve the list's original positional ordering. If a particular order is required, sort the set or use another approach that explicitly preserves first occurrences.

#**2. Difference between `print()` and `return` inside a function**

#`print()` displays text or a value to the output. `return` sends a value back to the code that called the function, so it can be stored, tested, or used in another calculation. Printing a value does not automatically make it the function's return value.

#**3. One limitation of `lambda` compared with `def`**

#A lambda expression is limited to a single expression and cannot contain a normal multi-statement function body. Use `def` for logic that needs multiple steps, documentation, or a descriptive function name.



######################################################
##################      Task 7      ##################
######################################################

customers = [
                {"id": 101, "name": " Ahmed ", "city": "cairo"},
                {"id": 102, "name": "Sara", "city": "GIZA"},
                {"id": 101, "name": "Ahmed", "city": "Cairo"},
                {"id": 103, "name": " Omar", "city": "cairo"},
                {"id": 104, "name": "Mona ", "city": "giza"}
            ]


def clean_customers(records):
    cleaned = []
    seen_ids = set()

    for record in records:
        customer_id = record["id"]

        if customer_id in seen_ids:
            continue

        seen_ids.add(customer_id)

        cleaned_record = {
            "id": customer_id,
            "name": record["name"].strip(),
            "city": record["city"].strip().title()
        }
        cleaned.append(cleaned_record)

    return cleaned

cleaned_customers = clean_customers(customers)
empty_cleaned_customers = clean_customers([])

customers_per_city = {}
for customer in cleaned_customers:
    city = customer["city"]
    customers_per_city[city] = customers_per_city.get(city, 0) + 1

print("Original data:", customers)
print("Cleaned data:", cleaned_customers)
print("Customers per city:", customers_per_city)
print("Empty input result:", empty_cleaned_customers)




######################################################
##################      Task 8      ##################
######################################################

orders = [
                {"customer": "Ahmed", "amount": 1200, "status": "Completed"},
                {"customer": "Sara", "amount": 850, "status": "Completed"},
                {"customer": "Ahmed", "amount": 400, "status": "Cancelled"},
                {"customer": "Omar", "amount": 600, "status": "Completed"},
                {"customer": "Sara", "amount": 300, "status": "Completed"}
            ]


def summarize_orders(orders):
    totals = {}

    for order in orders:
        if order["status"] == "Completed":
            customer = order["customer"]
            totals[customer] = totals.get(customer, 0) + order["amount"]

    return totals


customer_totals = summarize_orders(orders)
empty_order_totals = summarize_orders([])

sorted_totals = sorted(
                            customer_totals.items(),
                            key=lambda item: item[1],
                            reverse=True
                        )

if sorted_totals:
    highest_customer, highest_total = sorted_totals[0]
else:
    highest_customer, highest_total = None, 0

overall_completed_revenue = sum(customer_totals.values())

print("Customer totals:", customer_totals)
print("Sorted totals:", sorted_totals)
print("Highest customer:", highest_customer, "with", highest_total)
print("Overall completed revenue:", overall_completed_revenue)
print("Empty input result:", empty_order_totals)

def get_customers_above(totals, minimum=1000):
    return sorted([
        customer
        for customer, total in totals.items()
        if total > minimum
    ])


print("Customers above default minimum (1000):", get_customers_above(customer_totals))
print("Customers above custom minimum (500):", get_customers_above(customer_totals, minimum=500))




######################################################
##################      Task 9      ##################
######################################################


## Task 9 — Additional Concept Questions

#**1. What happens when you assign a new value to an existing dictionary key?**
#The existing value is replaced. The key is not duplicated; dictionaries have unique keys.

#**2. Difference between set `remove()` and `discard()`**
#`remove(value)` deletes the value but raises a `KeyError` if it is absent. `discard(value)` deletes it if present and does nothing if it is absent.

#**3. Why avoid modifying a list while iterating over it?**
#Adding or removing items changes list positions and length while the loop is traversing it. This can cause elements to be skipped or processed unexpectedly. A safer approach is to build a new list, or iterate over a copy when appropriate.

#**4. What do `map()` and `filter()` return in Python 3, and how can you display their results as lists?**
#They return iterator objects (`map` and `filter` objects), not lists. Wrap them with `list(...)`, for example `list(map(function, items))` and `list(filter(predicate, items))`.

#**5. Why round averages for display only after determining pass or fail?**
#Rounding too early can change the value used in the comparison. For example, an actual average of `59.6` may display as `60.00`, but it is still below a passing threshold of 60. Compare the full-precision average first, then round only when displaying it.