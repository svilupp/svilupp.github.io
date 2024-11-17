+++
title = "Welcome"
+++

~~~
<!-- Hero section with gradient background -->
<div class="container-fluid py-5 mb-4" style="background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);">
    <div class="container text-center text-white py-5">
        <h1 class="display-4 fw-bold mb-4">Welcome to Our Site</h1>
        <p class="lead mb-4">Explore insights and knowledge through our curated content.</p>
    </div>
</div>

<!-- Main content section -->
<div class="container">
    <div class="row g-4">
        <!-- Jan's Site Card -->
        <div class="col-md-6">
            <div class="card h-100 shadow-lg" data-bs-toggle="modal" data-bs-target="#janModal" style="cursor: pointer;">
                <div class="card-body text-center p-5">
                    <h5 class="card-title display-6 mb-3">Jan's Site</h5>
                    <p class="card-text lead">Click here to continue to Jan's site</p>
                </div>
            </div>
        </div>

        <!-- Ann's Site Card -->
        <div class="col-md-6">
            <div class="card h-100 shadow-lg" data-bs-toggle="modal" data-bs-target="#annModal" style="cursor: pointer;">
                <div class="card-body text-center p-5">
                    <h5 class="card-title display-6 mb-3">Ann's Site</h5>
                    <p class="card-text lead">Click here to continue to Ann's site</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Jan's Modal -->
<div class="modal fade" id="janModal" tabindex="-1" aria-labelledby="janModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="janModalLabel">Welcome to Jan's Site</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <img src="/assets/images/cartoon-boy.png" alt="Cartoon Boy" class="img-fluid mb-3" style="max-width: 200px;">
                <p class="lead">Click here to continue to Jan's site</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <a href="/jan/" class="btn btn-primary">Visit Jan's Site</a>
            </div>
        </div>
    </div>
</div>

<!-- Ann's Modal -->
<div class="modal fade" id="annModal" tabindex="-1" aria-labelledby="annModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="annModalLabel">Welcome to Ann's Site</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <img src="/assets/images/cartoon-girl.png" alt="Cartoon Girl" class="img-fluid mb-3" style="max-width: 200px;">
                <p class="lead">Click here to continue to Ann's site</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <a href="/ann/" class="btn btn-primary">Visit Ann's Site</a>
            </div>
        </div>
    </div>
</div>
~~~
