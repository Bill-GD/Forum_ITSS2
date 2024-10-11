<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
require_once '../config/database.php';
require_once '../app/models/User.php';
require_once '../app/models/Post.php';
require_once '../app/models/Comment.php';
class PostController
{
    public function addPost()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $content = $_POST['content'];
            $tag = $_POST['tag'];
            $user_id = $_SESSION['user']['user_id'];

            // Xử lý upload ảnh
            $image = '';
            if (!empty($_FILES['image']['name'])) {
                $image = time() . '_' . $_FILES['image']['name'];
                move_uploaded_file($_FILES['image']['tmp_name'], '../public/uploads/' . $image);
            }

            $postModel = new Post();
            $postModel->createPost($user_id, $content, $image, $tag);

            $_SESSION['successMessage'] = "記事が無事に投稿されました！";

            header("Location: index.php?paction=homePage");
            exit();
        }
    }

    public function showPosts()
    {
        $postModel = new Post();
        $posts = $postModel->getAllPosts();
        $tags = $postModel->getAllTags();
        $user = (new User())->getUserById($_SESSION['user']['user_id']);
        require_once '../app/views/homePage.php';
    }


    public function editPost()
    {
        if (isset($_GET['id'])) {
            $postModel = new Post();
            $post = $postModel->getPostById($_GET['id']);

            if ($post['user_id'] == $_SESSION['user']['user_id']) {
                require_once '../app/views/editPost.php';
            } else {
                $_SESSION['error_message'] = 'この記事を編集する権限がありません。';
                header("Location: index.php?paction=homePage");
                exit();
            }
        }
    }



    public function updatePost()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['id'])) {
            $postModel = new Post();
            $content = $_POST['content'];
            $tag = $_POST['tag'];

            $image = '';
            if (!empty($_FILES['image']['name'])) {
              $image = time() . '_' . $_FILES['image']['name'];
              move_uploaded_file($_FILES['image']['tmp_name'], '../public/uploads/' . $image);
            }

            echo $image;
            $postModel->updatePost($_POST['id'], $content, $image, $tag);

            $returnTo = isset($_POST['returnTo']) ? $_POST['returnTo'] : 'homePage';

            if ($returnTo === 'userInfo') {
                header("Location: index.php?paction=userInfo&id=" . $_SESSION['user']['user_id']);
            } else {
                header("Location: index.php?paction=homePage");
            }
            exit();
        } else {
            echo "Không thể cập nhật bài viết.";
        }
    }

    public function deletePost()
    {
        if (isset($_GET['id'])) {
            $postModel = new Post();
            $post = $postModel->getPostById($_GET['id']);

            $isAdmin = $_SESSION['user']['admin'] == 1;

            if ($isAdmin || $post['user_id'] == $_SESSION['user']['user_id']) {
                $postModel->deletePost($_GET['id']);
                header("Location: index.php?paction=homePage");
                exit();
            } else {
                echo 'Bạn không có quyền xóa bài viết này.';
            }
        }
    }


    public function postDetail()
    {
        if (isset($_GET['id'])) {
            $postModel = new Post();
            $commentModel = new Comment();
            $post = $postModel->getPostById($_GET['id']);
            $comments = $commentModel->getCommentsByPostId($_GET['id']);

            require_once '../app/views/postDetail.php';
        } else {
            echo 'Bài viết không tồn tại.';
        }
    }

    public function addComment()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $commentModel = new Comment();
            $post_id = $_POST['post_id'];
            $user_id = $_SESSION['user']['user_id'];
            $content = $_POST['content'];

            $commentModel->createComment($post_id, $user_id, $content);

            header("Location: index.php?paction=postDetail&id=" . $post_id);
            exit();
        }
    }

    public function toggleLike()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $post_id = $_POST['post_id'];
            $user_id = $_SESSION['user']['user_id'];

            $postModel = new Post();

            if ($postModel->hasLiked($post_id, $user_id)) {
                //unlike
                $postModel->removeLike($post_id, $user_id);
                echo json_encode(['status' => 'unliked']);
            } else {
                //like
                $postModel->addLike($post_id, $user_id);
                echo json_encode(['status' => 'liked']);
            }
        }
    }


    public function toggleSave()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $post_id = $_POST['post_id'];
            $user_id = $_SESSION['user']['user_id'];

            $postModel = new Post();

            if ($postModel->hasSaved($post_id, $user_id)) {
                //bỏ lưu
                $postModel->removeSave($post_id, $user_id);
            } else {
                //lưu
                $postModel->addSave($post_id, $user_id);
            }

            echo json_encode(['status' => 'success']);
        }
    }
    public function savedPosts()
    {
        $user_id = $_SESSION['user']['user_id'];
        $postModel = new Post();
        $savedPosts = $postModel->getSavedPostsByUser($user_id);

        require_once '../app/views/savedPosts.php'; // Điều chỉnh giống với postDetail
    }


    public function search()
    {
        require_once '../app/views/search.php';
    }


    // Xử lý tìm kiếm bài viết theo tag


    public function searchPost()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $tag = $_POST['tag'];
            $postModel = new Post();
            $posts = $postModel->searchPostsByTag($tag);

            require_once '../app/views/search.php';
        }
    }
}
