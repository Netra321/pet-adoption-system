<%-- 
    Document   : view_blogs
    Created on : 9 Jun 2025, 12:15:05 am
    Author     : Netra Patel
--%>
<%@ page import="java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="db_conn.jsp" %>
<%@ include file="navigation_page.html" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog - Our Latest Posts</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            line-height: 1.6;
        }

        .blog-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .blog-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .blog-header h1 {
            color: #2563eb;
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .blog-header p {
            color: #64748b;
            font-size: 1.1rem;
        }

        .blog-posts {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .blog-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(37, 99, 235, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 2px solid #bfdbfe;
        }

        .blog-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(37, 99, 235, 0.2);
        }

        .blog-card-content {
            display: flex;
            align-items: center;
            min-height: 200px;
        }

        .blog-image {
            flex: 0 0 300px;
            height: 200px;
            background: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            font-size: 1.2rem;
            font-weight: 500;
            border-right: 2px solid #bfdbfe;
            overflow: hidden;
        }

        .blog-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .blog-text {
            flex: 1;
            padding: 2rem;
        }

        .blog-title {
            font-size: 1.5rem;
            color: #1e40af;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .blog-meta {
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .blog-excerpt {
            color: #475569;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .read-more {
            display: inline-block;
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border: 2px solid #2563eb;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .read-more:hover {
            background-color: #2563eb;
            color: white;
        }

        .no-posts {
            text-align: center;
            padding: 3rem;
            color: #666;
            font-size: 1.1rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .blog-card-content {
                flex-direction: column;
                min-height: auto;
            }

            .blog-image {
                flex: none;
                width: 100%;
                height: 150px;
                border-right: none;
                border-bottom: 2px solid #bfdbfe;
            }

            .blog-text {
                padding: 1.5rem;
            }

            .blog-header h1 {
                font-size: 2rem;
            }

            .blog-container {
                padding: 0 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="blog-container">
        <div class="blog-header">
            <h1>Pet Adoption Stories & Tips</h1>
            <p>Discover heartwarming adoption stories and helpful pet care guides</p>
        </div>

        <div class="blog-posts">
            <%
                // Pet adoption blog posts data
                String[][] blogPosts = {
                    {"1", "The Five Freedoms of Animal Welfare: What Every Pet Deserves", "", "Ruchita Mahale", "Jun 02, 2025", "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhXG7KlGpzyRCPvNJWvw-LM_7AsuIwx8gE818_Jnu7R3w-N52-0qfZ5wEW-XHUJFDSp94b1VPozXf_sYDPYYHniX_rEiXOAYaMujW4jc2Rv1sIdxM9FMh6BqdSdArc5uh1dy665RjeAJDavio5LqZOWHm5LE4vO1MvPUZBuxUrl6U2AXuGORzOfhN9TsMw/s974/Screenshot%202025-06-03%20044337.png", "https://foreverfurandlove.blogspot.com/2025/06/the-five-freedoms-of-animal-welfare.html"},
                    {"2", "The Joys of Adopting Senior Pets: Why Older Animals Make Amazing Companions", "", "Ruchita Mahale", "Jun 02, 2025", "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhCTdHalnMBO0_TwPCs31ag7QPvvMB9Yc1oBDb1lLUS2dEhfo8n1UmFsswhWPw2Vb61dYGPnwIGXOzxqq0Y1090oWabi_cxSnEQ4XKy23DoYLLl8RdZ2E1YPZDb1xwQMcjjkbDm0_esg76bfRw7Fr_wFxweAgzjrU5XpJiosVwmdddFHvguz3Vnm33k9Lw/s2240/adopt_senior_pet.png", "https://foreverfurandlove.blogspot.com/2025/06/the-joys-of-adopting-senior-pets-why.html"},
                    {"3", "How Pets Improve Our Mental Health", "", "Ruchita Mahale", "Jun 02, 2025", "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEilV9B6EJSHinardiVTEfF0d6nqmLHD6ZTKMgm4xRESII29ioxipXbup3M5qsQqXMgZ3MlL2HetaI6rha2sLUmTW5JUiskMrtxAvc4myn9XFU-OrxdnrOHWPSxP_5BSjOlholM10qWF6XL1SnsvaK5hz3WvAwlap1NKPN1xAxLJmAhXzYSrFu1YH8m40MY/s2240/Healing%20comes%20with%20a%20paw.png", "https://foreverfurandlove.blogspot.com/2025/06/how-pets-improve-our-mental-health.html"},
                    {"4", "'Why Adopt, Not Shop?' — The Importance of Choosing Adoption Over Buying", "", "Ruchita Mahale", "Jun 01, 2025", "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgF7KPnQkaC-sRC21q90Lhregu-fiQFCGVV7QmQh1qty1_DePNMnKaz5Iav07Wg1OGWL5wqxBoofaGs1JKMzfne73odeK6_SjYUa0_mxC_NJI-gn_aqIBBESOUaO-Ib5k7Rd7Gcf4IEMisLGQRW8D_-siFI-r4Cyb9PKaPfkumYASDdGkNoWYd-Thh9sXtc/s1280/Adopt%20Us.png", "https://foreverfurandlove.blogspot.com/2025/06/why-adopt-not-shop-importance-of.html"},
                    {"5", "Dog & Cat Vaccination Timeline Every Pet Parent Should Know", "", "Ruchita Mahale", "May 28, 2025", "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhtodYpvwMjHN-2YrIk78UckkyjClmVHzURrxA7s2PSXICFhJ6pCmnz8bH0jX3NDYotaess32sMbmyHNkwlXwCAq3iUJiCWwvmKFL_D6v74V0uQfiszKCanH1rzuNdi2phU3z9b-QUVqhecBqrjXgZWU5TfJmhwsFWcNiuDM_NMBRKTfpEwpr7u5VYArHSf/s1280/vaccinate_pet_blog_img%20(1).png", "https://foreverfurandlove.blogspot.com/2025/05/dog-cat-vaccination-timeline-every-pet.html"}
                };
                
                for (String[] post : blogPosts) {
                    String id = post[0];
                    String title = post[1];
                    String content = post[2];
                    String author = post[3];
                    String date = post[4];
                    String imageUrl = post[5];
                    String blogUrl = post[6];
                    
                    // Create excerpt (first 150 characters)
                    String excerpt = content.length() > 150 ? content.substring(0, 150) + "..." : content;
            %>
                    <div class="blog-card">
                        <div class="blog-card-content">
                            <div class="blog-image">
                                <img src="<%= imageUrl %>" alt="<%= title %>" onerror="this.style.display='none'; this.parentNode.innerHTML='<div style=\'display:flex;align-items:center;justify-content:center;height:100%;color:#64748b;\'>Pet Image</div>';">
                            </div>
                            <div class="blog-text">
                                <h2 class="blog-title"><%= title %></h2>
                                <div class="blog-meta">
                                    By <%= author %> • <%= date %>
                                </div>
                                <p class="blog-excerpt"><%= excerpt %></p>
                                <a href="<%= blogUrl %>" target="_blank" class="read-more">Read Full Story</a>
                            </div>
                        </div>
                    </div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>