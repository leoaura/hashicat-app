#!/bin/bash
# Copyright (c) HashiCorp, Inc.

# Script to deploy a very simple web application.
# The web app has a customizable image and some text.

cat << EOM > /var/www/html/index.html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Meow! — ${PREFIX}</title>
  <meta name="description" content="A tiny, elegant demo page with a dynamic placeholder image."/>
  <link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='64' height='64'%3E%3Ctext y='55' x='5' font-size='56'%3E🐾%3C/text%3E%3C/svg%3E">

  <style>
    :root{
      --bg:#0e0f14; --card:#151822; --fg:#eaeaf2; --muted:#a3a3b2;
      --accent:#9b87f5; --ring: rgba(155,135,245,.35);
    }
    @media (prefers-color-scheme: light){
      :root{ --bg:#f7f8fb; --card:#ffffff; --fg:#111318; --muted:#595d6a; --accent:#6f57f4; --ring:rgba(111,87,244,.28);}
    }

    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0; color:var(--fg);
      background:
        radial-gradient(1200px 700px at 50% -10%, rgba(155,135,245,.12), transparent 60%),
        linear-gradient(180deg, rgba(111,87,244,.06), transparent 25%),
        var(--bg);
      font:16px/1.6 system-ui,-apple-system,Segoe UI,Roboto,Inter,Arial,sans-serif;
      -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
    }

    .container{max-width:1000px;margin:0 auto;padding:28px}
    .nav{display:flex;align-items:center;justify-content:space-between;margin:6px 0 16px}
    .brand{display:flex;align-items:center;gap:10px}
    .badge{font-size:12px;padding:3px 10px;border-radius:999px;border:1px solid var(--ring);background:rgba(155,135,245,.12)}
    .status{color:var(--muted);font-size:0.95rem}

    .card{
      background:linear-gradient(180deg, rgba(155,135,245,.08), rgba(155,135,245,.02)), var(--card);
      border:1px solid rgba(155,135,245,.18);
      border-radius:20px; box-shadow:0 20px 60px rgba(0,0,0,.35); overflow:hidden;
    }

    .hero{display:grid;grid-template-columns:1.05fr .95fr;gap:12px}
    @media (max-width:900px){ .hero{grid-template-columns:1fr} }

    .pane{padding:28px}
    h1{font-size:clamp(26px,3.2vw,40px);line-height:1.2;margin:6px 0 10px}
    .lead{color:var(--muted);margin-bottom:18px}

    .cta{display:flex;gap:10px;flex-wrap:wrap}
    .btn{
      appearance:none;border:1px solid var(--ring);background:transparent;
      padding:10px 14px;border-radius:12px;color:var(--fg);cursor:pointer;
      transition:transform .08s ease, box-shadow .15s ease, background .2s ease;
    }
    .btn.primary{background:var(--accent);border-color:transparent;color:#fff}
    .btn:hover{transform:translateY(-1px);box-shadow:0 10px 26px rgba(0,0,0,.25)}
    .btn:focus{outline:none;box-shadow:0 0 0 4px var(--ring)}

    .imgwrap{position:relative}
    .image{
      display:block;width:100%;height:auto;aspect-ratio:16/9;object-fit:cover;
      border-radius:0 0 20px 20px; border-top:1px solid rgba(255,255,255,.06);
      box-shadow:inset 0 0 0 1px rgba(255,255,255,.04);
    }
    @media (min-width:901px){
      .image{border-radius:0 20px 20px 0;border-left:1px solid rgba(255,255,255,.06);border-top:none}
    }

    .features{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;padding:0 28px 24px}
    @media (max-width:900px){ .features{grid-template-columns:1fr;padding:0 16px 20px} }

    .tile{
      padding:16px;border-radius:14px;border:1px solid rgba(255,255,255,.08);
      background:linear-gradient(180deg, rgba(123,220,181,.08), rgba(123,220,181,.02));
    }
    .muted{color:var(--muted)}
    .mono{font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace}

    footer{padding:22px 0;text-align:center;color:var(--muted);font-size:.95rem}
    .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}
  </style>
</head>
<body>
  <a class="sr-only" href="#main">본문으로 건너뛰기</a>

  <div class="container">
    <nav class="nav" aria-label="상단">
      <div class="brand">
        <span class="badge">Demo</span>
        <strong>${PREFIX}</strong>
      </div>
      <div class="status">상태: Online</div>
    </nav>

    <main id="main" class="card hero" role="main">
      <section class="pane">
        <h1>Meow World!</h1>
        <p class="lead">Welcome to <strong>${PREFIX}</strong>'s app. 이 페이지는 반응형·접근성·다크/라이트 테마를 기본 지원합니다.</p>

        <div class="cta" role="group" aria-label="동작">
          <button class="btn primary" onclick="alert('Have a purr-fect day! 🐱')">시작하기</button>
          <button class="btn" onclick="shuffle()">이미지 바꾸기</button>
        </div>

        <div class="features" aria-label="특징">
          <div class="tile">
            <h3>간단 배포</h3>
            <p class="muted"><span class="mono">index.html</span>만 배치하면 바로 동작합니다.</p>
          </div>
          <div class="tile">
            <h3>유연한 커스터마이즈</h3>
            <p class="muted">배포 스크립트 변수로 제목/본문/이미지 크기를 제어하세요.</p>
          </div>
          <div class="tile">
            <h3>접근성 고려</h3>
            <p class="muted">Skip link, 명확한 대체텍스트, 키보드 포커스 스타일.</p>
          </div>
        </div>
      </section>

      <aside class="imgwrap" aria-label="미리보기 이미지">
        <img
          id="hero"
          class="image"
          src="http://${PLACEHOLDER}/${WIDTH}/${HEIGHT}"
          alt="Dynamic image from ${PLACEHOLDER} sized ${WIDTH}×${HEIGHT}">
      </aside>
    </main>

    <footer>
      © <span id="year"></span> ${PREFIX}. All rights reserved.
    </footer>
  </div>

  <script>
    // 연도 자동 표기
    document.getElementById('year').textContent = new Date().getFullYear();

    // 캐시를 피하기 위한 간단한 셔플(쿼리 파라미터 추가)
    function shuffle(){
      var el = document.getElementById('hero');
      try{
        var u = new URL(el.src);
        u.searchParams.set('r', Math.floor(Math.random()*1e6));
        el.src = u.toString();
      }catch(e){
        // URL 파싱이 실패하면 단순 캐시 버스터
        el.src = el.src.split('?')[0] + '?r=' + Math.floor(Math.random()*1e6);
      }
    }
  </script>

  <noscript>
    <div class="container" style="color:#a3a3b2">
      JavaScript가 비활성화되어 있습니다 — 페이지는 동작하지만 “이미지 바꾸기” 버튼은 비활성입니다.
    </div>
  </noscript>
</body>
</html>

EOM

echo "Script complete."
