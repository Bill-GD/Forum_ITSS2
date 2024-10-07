<?php
require_once '../config/database.php';

class Post
{
    private $conn;

    public function __construct()
    {
        $this->conn = (new Database())->getConnection();
    }

    // Tạo bài post mới
    public function createPost($user_id, $content, $image, $tag)
    {
        $stmt = $this->conn->prepare(
            "INSERT INTO post (user_id, content, image, tag, like_count, date_created) 
             VALUES (?, ?, ?, ?, 0, NOW())"
        );

        if ($stmt === false) {
            die('Lỗi khi chuẩn bị câu truy vấn: ' . $this->conn->error);
        }

        $stmt->bind_param("isss", $user_id, $content, $image, $tag);

        if (!$stmt->execute()) {
            die('Lỗi khi thực thi câu truy vấn: ' . $stmt->error);
        }

        return true;
    }

    // Lấy tất cả các bài post
    public function getAllPosts()
    {
        $sql = "SELECT post.*, user.usernames FROM post 
                JOIN user ON post.user_id = user.user_id 
                ORDER BY date_created DESC";

        $result = $this->conn->query($sql);

        if ($result === false) {
            die('Lỗi khi thực thi câu truy vấn: ' . $this->conn->error);
        }

        $posts = [];
        while ($row = $result->fetch_assoc()) {
            $posts[] = $row;
        }

        return $posts;
    }

    public function getPostById($id)
    {
        $stmt = $this->conn->prepare(
            "SELECT post.*, user.usernames FROM post 
             JOIN user ON post.user_id = user.user_id 
             WHERE post.id = ?"
        );
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_assoc();
    }


    public function updatePost($id, $content, $tag)
    {
        $stmt = $this->conn->prepare("UPDATE post SET content = ?, tag = ? WHERE id = ?");
        if (!$stmt) {
            echo "Prepare failed: (" . $this->conn->errno . ") " . $this->conn->error;
            return false;
        }
        $stmt->bind_param("ssi", $content, $tag, $id);
        if (!$stmt->execute()) {
            echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
            return false;
        }
        return true;
    }

    public function deletePost($id)
    {
        $stmt = $this->conn->prepare("DELETE FROM post WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
    }

    public function hasLiked($post_id, $user_id)
    {
        $stmt = $this->conn->prepare("SELECT * FROM post_likes WHERE post_id = ? AND user_id = ?");
        $stmt->bind_param("ii", $post_id, $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->num_rows > 0;
    }

    // Thêm like
    public function addLike($post_id, $user_id)
    {
        $stmt = $this->conn->prepare("INSERT INTO post_likes (post_id, user_id) VALUES (?, ?)");
        $stmt->bind_param("ii", $post_id, $user_id);
        $stmt->execute();

        $stmt = $this->conn->prepare("UPDATE post SET like_count = like_count + 1 WHERE id = ?");
        $stmt->bind_param("i", $post_id);
        $stmt->execute();
    }

    // Xóa like
    public function removeLike($post_id, $user_id)
    {
        $stmt = $this->conn->prepare("DELETE FROM post_likes WHERE post_id = ? AND user_id = ?");
        $stmt->bind_param("ii", $post_id, $user_id);
        $stmt->execute();

        $stmt = $this->conn->prepare("UPDATE post SET like_count = like_count - 1 WHERE id = ?");
        $stmt->bind_param("i", $post_id);
        $stmt->execute();
    }


    // Kiểm tra nếu user đã lưu bài viết
    public function hasSaved($post_id, $user_id)
    {
        $stmt = $this->conn->prepare("SELECT * FROM saved_posts WHERE post_id = ? AND user_id = ?");
        $stmt->bind_param("ii", $post_id, $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->num_rows > 0;
    }

    // Thêm bài viết vào danh sách yêu thích
    public function addSave($post_id, $user_id)
    {
        $stmt = $this->conn->prepare("INSERT INTO saved_posts (post_id, user_id) VALUES (?, ?)");
        $stmt->bind_param("ii", $post_id, $user_id);
        $stmt->execute();
    }

    // Xóa bài viết khỏi danh sách yêu thích
    public function removeSave($post_id, $user_id)
    {
        $stmt = $this->conn->prepare("DELETE FROM saved_posts WHERE post_id = ? AND user_id = ?");
        $stmt->bind_param("ii", $post_id, $user_id);
        $stmt->execute();
    }

    public function getSavedPostsByUser($user_id)
    {
        $stmt = $this->conn->prepare("
        SELECT post.* 
        FROM post 
        INNER JOIN saved_posts ON post.id = saved_posts.post_id 
        WHERE saved_posts.user_id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function searchPostsByTag($tag) {
        global $conn; // Kết nối database của bạn

        // Sử dụng prepared statement để bảo vệ khỏi SQL injection
        $stmt = $conn->prepare("SELECT * FROM posts WHERE tag LIKE ?"); // Giả sử bảng của bạn là 'posts'
        $searchTerm = "%$tag%"; // Tạo điều kiện tìm kiếm
        $stmt->bind_param("s", $searchTerm);
        $stmt->execute();
        $result = $stmt->get_result();

        // Lưu kết quả vào mảng
        $posts = [];
        while ($row = $result->fetch_assoc()) {
            $posts[] = $row;
        }

        return $posts;
    }
}
