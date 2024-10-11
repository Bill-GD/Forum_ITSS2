-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 09, 2024 lúc 05:49 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `forum_it`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post`
--

CREATE TABLE `post` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `like_count` int(11) DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `tag` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post`
--

INSERT INTO `post` (`id`, `user_id`, `content`, `image`, `like_count`, `date_created`, `tag`) VALUES
(18, 32, 'Món bún chả Hà Nội dân dã - niềm tự hào của vùng đất Hà thành nói riêng và Việt Nam nói chung hứa hẹn sẽ mang đến bạn cùng người thân trải nghiệm ẩm thực vô cùng độc đáo.\r\nMón ăn gồm 3 phần chính là sự kết hợp đặc biệt hài hòa giữa sợi bún nhỏ dai dai, thơm ngon, chả nướng đậm đà hương vị cùng chén nước chấm được pha chua chua, ngọt.\r\nKhi thưởng thức bún chả, để trải nghiệm ẩm thực Hà thành thêm phần trọn vẹn bạn nên dùng chung món ăn với đa dạng các loại rau sống tươi mát như xà lách, tía tô, húng quế, giá đỗ, kinh giới... ', '1728446162_buncha.jpeg', 2, '2024-10-09 03:56:02', 'Buncha'),
(19, 32, 'Phở bò gia truyền ba đời ở Nam Định\r\nĐối với phở bò sốt vang, thịt được sử dụng chủ yếu là nạm bò lấy từ ức, vai, cổ bò. Sau khi ngâm nước muối, thịt được luộc chín rồi rửa lại bằng nước sạch mới thái thành từng tảng để ướp gia vị. Thịt đã ướp được xào kỹ rồi mới cho nước phở vào ninh. Ngoài cà chua và nước phở, quán không cho quế, hồi, thảo quả, dầu điều hay dầu gấc để tạo màu. Do vậy, thịt không có màu đỏ đẹp mắt nhưng mềm và thấm vị ngọt từ nước dùng.', '1728446546_pho.jpg', 1, '2024-10-09 04:02:26', 'Phobo'),
(20, 18, '\r\nゲアンの朝食といえばパンは欠かせません。ゲアンのバインミーと鰻のスープは意外にもよく合います。濃厚なスープに浸したサクサクのパンに、鰻の甘みと唐辛子と胡椒のスパイシーさが染み込んでおり、一度食べたら一生忘れられないこと間違いなし！うなぎのスープは、遅生まれながら、歯ごたえのある身と脂の乗った出汁に多くの人が魅了されます。ターメリック、唐辛子、胡椒から立ち上る香りと、エシャロットの辛味が、食べた人を唸らせる美味しさです。', '1728447625_supluon.jpg', 1, '2024-10-09 04:20:25', 'supluon');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_likes`
--

CREATE TABLE `post_likes` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `post_likes`
--

INSERT INTO `post_likes` (`id`, `post_id`, `user_id`) VALUES
(159, 18, 18),
(155, 18, 32),
(158, 19, 18),
(156, 20, 18);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `saved_posts`
--

CREATE TABLE `saved_posts` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `saved_posts`
--

INSERT INTO `saved_posts` (`id`, `post_id`, `user_id`) VALUES
(35, 19, 18);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `usernames` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `passwords` varchar(255) NOT NULL,
  `date_created` datetime NOT NULL,
  `profile_picture` varchar(255) NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user`
--

INSERT INTO `user` (`user_id`, `usernames`, `email`, `passwords`, `date_created`, `profile_picture`, `admin`) VALUES
(18, 'VietCee', 'buiviet57.v5@gmail.com', 'Viet12345', '2024-09-19 18:50:32', '1728443743_1651526332736.jpg', 1),
(19, 'ThanhHoDuc', 'DucThanh@gmail.com', 'DucThanh2003', '2024-09-19 18:50:32', '', 1),
(22, 'hungvu', 'hi@gmail.com', '1111111a', '2024-09-24 05:30:04', '1728297627_DB280072-4A49-49A2-9517-DDD4D29FE2E4 (1).jpeg', 0),
(32, 'ThanhHoang', 'hi1@gmail.com', '1111111a', '2024-10-09 05:51:54', '1728445966_329829817_958310021853016_2910198958344583684_n.jpg', 0),
(33, 'DatLeTran', 'hi2@gmail.com', '1111111a', '2024-10-09 05:52:16', '', 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_post` (`post_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `saved_posts`
--
ALTER TABLE `saved_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_post` (`post_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `post`
--
ALTER TABLE `post`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT cho bảng `saved_posts`
--
ALTER TABLE `saved_posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT cho bảng `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Các ràng buộc cho bảng `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Các ràng buộc cho bảng `post_likes`
--
ALTER TABLE `post_likes`
  ADD CONSTRAINT `post_likes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`),
  ADD CONSTRAINT `post_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Các ràng buộc cho bảng `saved_posts`
--
ALTER TABLE `saved_posts`
  ADD CONSTRAINT `saved_posts_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`),
  ADD CONSTRAINT `saved_posts_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
