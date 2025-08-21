<p align="center">
  <h1>ecommerce_app</h1>
</p>

This is a responsive e-commerce app with Supabase authentication, database, and storage for profile picture and products. Includes add to cart, product search, and map-based address selection for delivery. For payment added Razorpay. Tried to keep scalable modular codebase with Provider state management and robust error handling as much as possible

<hr>

### App Screenshot

<hr>

[🔗Watch live demo](https://www.youtube.com/shorts/BDC9ujk8LoA)

Login and Register page
<div style="display: flex; gap: 10px;">
  <img src="demo/d1.png" height="500"/>
  <img src="demo/d2.png" height="500"/>
</div>
<br>
Product and Search
<div>

  <img src="demo/d3.png" height="500"/>
  <img src="demo/d4.png" height="500"/>
  <img src="demo/d5.png" height="500"/>
</div>

</br>
Checkout and Location
<div>
  <img src="demo/d8.png" height="500"/>
  <img src="demo/d10.png" height="500"/>
  <img src="demo/d9.png" height="500"/>
</div>

</br>
Payment
<div>

  <img src="demo/d11.png" height="500"/>
  <img src="demo/d12.png" height="500"/>
</div>
</br>

### Database Schema (PostgreSQL)

<hr>

<img src="demo/schema.png" width="900">

### Problems Faced

<hr>

- Integrating supabase authentication with provider while maintaining clean code structure. Got confused on setting up the row level security for the database.
- Handling asynchronous image uploads to Supabase Storage and updating state.
- Razorpay integration with flutter.
