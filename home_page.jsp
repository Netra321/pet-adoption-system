<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Paws & Claws – Find Your Fur‑ever Friend</title>
    <link rel="stylesheet" href="home.css">
</head>
<body>

    <!-- ━━━━━━━━━━ HEADER ━━━━━━━━━━-->
    <header class="header">
        <div class="logo">Paws&nbsp;🐾</div>

        <!-- Navigation / Search bar  -->
        <nav class="nav">
            <a href="#about">About</a>
            <a href="#features">Features</a>
            <a href="#stories">Stories</a>
            <a href="#blog">Blog</a>
            <a href="login.jsp" class="btn">Login</a>
        </nav>
        <button class="burger" aria-label="Menu"></button>
    </header>

    <!-- ━━━━━━━━━━ HERO ━━━━━━━━━━-->
    <section class="hero" id="about">
        <div class="hero__text">
            <h1>Adopt. Love. Repeat.</h1>
            <p>Paws&nbsp;&amp;&nbsp;Claws connects loving families with pets who need a home.
               Search hundreds of adorable cats, dogs and small animals near you.</p>
            <a href="view_pet.jsp" class="btn">Find a Pet</a>
        </div>

        <div class="hero__img">
            <img src="assets/hero‑dog.png" alt="Happy dog with new owner">
        </div>
    </section>

    <!-- ━━━━━━━━━━ FEATURES ━━━━━━━━━━-->
    <section class="features" id="features">
        <h2>What We Do</h2>
        <div class="feature‑grid">
            <div class="card">🩺  Full vet‑check &amp; vaccines</div>
            <div class="card">📋  Transparent adoption process</div>
            <div class="card">🤝  Post‑adoption support</div>
        </div>
    </section>

    <!-- ━━━━━━━━━━ STORIES ━━━━━━━━━━-->
    <section class="stories" id="stories">
        <h2>Happy Tails</h2>
        <p class="lead">Real stories from families who found their perfect companion.</p>
        <!-- slider / cards / etc. -->
    </section>

    <!-- ━━━━━━━━━━ BLOG ━━━━━━━━━━-->
    <section class="blog" id="blog">
        <h2>From Our Blog</h2>
        <!-- teaser articles -->
    </section>

    <footer class="footer">
        © <%= java.time.Year.now() %> Paws & Claws. All rights reserved.
    </footer>

<script>
/* tiny mobile nav toggle */
const burger = document.querySelector('.burger');
const nav = document.querySelector('.nav');
burger.onclick = () => nav.classList.toggle('open');
</script>
</body>
</html>
