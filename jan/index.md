+++
title = "Jan's Scratchpad"
+++

~~~
<!-- Hero section with Tailwind CSS -->
<div class="relative overflow-hidden bg-gradient-to-br from-indigo-600 to-purple-900 mb-8">
  <div class="max-w-7xl mx-auto">
    <div class="relative z-10 pb-8 sm:pb-16 md:pb-20 lg:max-w-2xl lg:w-full lg:pb-28 xl:pb-32">
      <main class="mt-10 mx-auto max-w-7xl px-4 sm:mt-12 sm:px-6 md:mt-16 lg:mt-20 lg:px-8 xl:mt-28">
        <div class="sm:text-center lg:text-left">
          <h1 class="text-4xl tracking-tight font-extrabold text-white sm:text-5xl md:text-6xl">
            <span class="block">Jan's</span>
            <span class="block text-indigo-200">Scratchpad</span>
          </h1>
          <p class="mt-3 text-base text-gray-300 sm:mt-5 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-5 md:text-xl lg:mx-0">
            Welcome to my digital garden! This is where I share my thoughts, experiments, and learnings about technology, data science, and programming.
          </p>
        </div>
      </main>
    </div>
  </div>
</div>

<!-- Content section -->
<div class="container mt-5">
    <!-- Recent Posts Section -->
    <div class="mb-5">
        <h2 class="display-6 mb-4">Recent Posts</h2>
        <div class="row row-cols-1 row-cols-md-3 g-4 mx-0">
            {{blogposts}}
        </div>
    </div>

    <!-- Two Column Layout for WIP and About -->
    <div class="row">
        <div class="col-lg-8">
            <!-- WIP Posts Section -->
            {{wipposts}}
        </div>
        <div class="col-lg-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">About</h5>
                    <p class="card-text">Welcome to my personal site where I share thoughts, ideas, and insights about technology, data science, and more.</p>
                    <a href="/jan/about/" class="btn btn-primary">Learn More</a>
                </div>
            </div>
        </div>
    </div>
</div>
~~~
