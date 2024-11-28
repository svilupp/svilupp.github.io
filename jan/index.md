+++
title = "Jan's Scratchpad"
indexpage = true
+++

~~~
<!-- Hero section with explicit width -->
<div class="relative bg-gradient-to-br from-indigo-600 to-purple-900">
  <div class="w-full px-4 sm:px-6 lg:px-8">
    <div class="relative py-8">
      <div class="text-center">
        <h1 class="text-3xl tracking-tight font-bold text-white sm:text-4xl">
          <span class="block">Jan's</span>
          <span class="block text-indigo-200">Scratchpad</span>
        </h1>
        <p class="mt-4 text-base text-gray-300 sm:max-w-xl lg:max-w-2xl mx-auto">
          Welcome to my digital garden! This is where I share my thoughts, experiments, and learnings about technology, data science, and programming.
        </p>
      </div>
    </div>
  </div>
</div>

<!-- Content section with explicit width -->
<div class="w-full px-4 sm:px-6 lg:px-8 py-8">
    <!-- Recent Posts Section -->
    <div class="mb-12">
        <h2 class="text-2xl font-bold mb-6 text-gray-900">Recent Posts</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
            {{recentposts}}
        </div>
        <div class="text-center mt-6">
            <a href="/jan/scratchpad/" class="inline-block px-6 py-3 bg-indigo-700 text-base font-medium text-white rounded-md hover:bg-indigo-800 transition-colors shadow-sm">
                View All Posts
            </a>
        </div>
    </div>

    <!-- WIP Posts Section -->
    <div class="mb-12">
        <h2 class="text-2xl font-bold mb-6 text-gray-900">Work in Progress</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
            {{recentwipposts}}
        </div>
    </div>

    <!-- About Section -->
    <div class="mb-12">
        <div class="w-full max-w-5xl mx-auto">
            <div class="bg-white rounded-lg shadow-sm p-6 border border-gray-200">
                <h2 class="text-lg font-bold mb-3 text-gray-900">About</h2>
                <p class="text-base text-gray-600 mb-4">Welcome to my personal site where I share thoughts, ideas, and insights about technology, data science, and more.</p>
                <a href="/jan/about/" class="inline-block px-6 py-3 bg-indigo-700 text-base font-medium text-white rounded-md hover:bg-indigo-800 transition-colors shadow-sm">
                    Learn More
                </a>
            </div>
        </div>
    </div>
</div>
~~~
