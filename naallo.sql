-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 26, 2025 at 05:48 PM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 7.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ems_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `activity_type` varchar(50) DEFAULT NULL,
  `description` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`log_id`, `user_id`, `activity_type`, `description`, `ip_address`, `created_at`) VALUES
(51, 9, 'leave_update', 'Manager approved leave request #13 for employee ID 3', NULL, '2025-06-25 16:31:13'),
(52, 1, 'leave_update', 'Updated leave request #15 status to approved', NULL, '2025-06-25 17:35:07');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `attendance_id` int(11) NOT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `attendance_date` date NOT NULL,
  `time_in` time DEFAULT NULL,
  `time_out` time DEFAULT NULL,
  `status` enum('present','late','absent','half-day') DEFAULT 'present',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_hours` decimal(4,2) DEFAULT NULL,
  `auto_status` enum('present','late','absent','half-day') DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `device_info` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`attendance_id`, `emp_id`, `attendance_date`, `time_in`, `time_out`, `status`, `notes`, `created_at`, `total_hours`, `auto_status`, `ip_address`, `device_info`) VALUES
(1, 3, '2025-04-11', '01:36:00', '00:00:00', 'present', 'vbgfgf fhgfjh fgfjk', '2025-04-11 03:37:22', NULL, NULL, NULL, NULL),
(2, 3, '2025-04-12', '09:47:00', '21:47:00', 'late', '', '2025-04-12 06:47:48', NULL, NULL, NULL, NULL),
(3, 3, '2025-04-14', '09:41:37', '09:49:57', 'present', NULL, '2025-04-14 07:41:37', NULL, NULL, NULL, NULL),
(4, 5, '2025-04-14', '17:01:36', '20:00:21', 'present', NULL, '2025-04-14 15:01:36', NULL, NULL, NULL, NULL),
(5, 5, '2025-04-15', '08:51:46', '08:51:48', 'present', NULL, '2025-04-15 06:51:46', NULL, NULL, NULL, NULL),
(6, 3, '2025-04-15', '08:57:52', NULL, 'present', NULL, '2025-04-15 06:57:52', NULL, NULL, NULL, NULL),
(7, NULL, '2025-04-22', '10:51:46', NULL, 'present', NULL, '2025-04-22 08:51:46', NULL, NULL, NULL, NULL),
(8, NULL, '2025-04-22', '10:51:53', NULL, 'present', NULL, '2025-04-22 08:51:53', NULL, NULL, NULL, NULL),
(9, NULL, '2025-04-22', '10:52:02', NULL, 'present', NULL, '2025-04-22 08:52:02', NULL, NULL, NULL, NULL),
(10, NULL, '2025-04-22', '10:52:08', NULL, 'present', NULL, '2025-04-22 08:52:08', NULL, NULL, NULL, NULL),
(11, 3, '2025-04-22', '10:52:36', '12:59:10', 'present', NULL, '2025-04-22 08:52:36', NULL, NULL, NULL, NULL),
(13, 5, '2025-04-22', '13:55:14', '13:55:15', 'present', NULL, '2025-04-22 11:55:14', NULL, NULL, NULL, NULL),
(16, 5, '2025-04-23', '10:38:59', '10:39:11', 'late', NULL, '2025-04-23 08:38:59', '0.00', 'late', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
(20, 3, '2025-04-24', '09:23:36', '09:40:39', 'late', NULL, '2025-04-24 07:23:36', '0.28', 'late', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
(21, 5, '2025-04-24', '09:45:27', NULL, 'late', NULL, '2025-04-24 07:45:27', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
(26, 5, '2025-04-25', '17:16:53', NULL, 'late', NULL, '2025-04-25 15:16:53', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
(27, 3, '2025-04-25', '17:17:46', NULL, 'late', NULL, '2025-04-25 15:17:46', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
(28, 5, '2025-05-02', '18:40:51', NULL, 'late', NULL, '2025-05-02 16:40:51', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
(29, NULL, '2025-05-02', '19:43:16', NULL, 'late', NULL, '2025-05-02 17:43:16', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'),
(30, 5, '2025-05-27', '21:42:19', '23:09:43', 'late', NULL, '2025-05-27 19:42:19', '1.46', 'late', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36'),
(31, 5, '2025-05-28', '05:47:25', NULL, 'late', NULL, '2025-05-28 02:47:25', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36'),
(32, 3, '2025-05-28', '19:37:26', '20:10:05', 'late', NULL, '2025-05-28 17:37:26', '0.54', 'late', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36'),
(33, 3, '2025-05-29', '04:49:13', NULL, 'late', NULL, '2025-05-29 02:49:13', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36'),
(34, 3, '2025-05-31', '05:38:39', NULL, 'late', NULL, '2025-05-31 03:38:39', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36'),
(35, 3, '2025-06-05', '20:43:20', '20:43:34', 'late', NULL, '2025-06-05 18:43:20', '0.00', 'late', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36'),
(36, 5, '2025-06-13', '22:09:47', NULL, 'late', NULL, '2025-06-13 18:09:47', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36'),
(38, 3, '2025-06-25', '16:01:17', NULL, 'late', NULL, '2025-06-25 12:01:17', NULL, NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36'),
(39, 5, '2025-06-25', '17:38:58', '17:39:31', 'late', NULL, '2025-06-25 13:38:58', '0.01', 'late', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36'),
(40, 45, '2025-06-26', '18:36:23', '17:37:03', 'late', NULL, '2025-06-26 14:36:23', '-0.99', 'late', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_bonus_config`
--

CREATE TABLE `attendance_bonus_config` (
  `config_id` int(11) NOT NULL,
  `min_attendance_percentage` decimal(5,2) NOT NULL,
  `max_attendance_percentage` decimal(5,2) NOT NULL,
  `bonus_percentage` decimal(5,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attendance_bonus_config`
--

INSERT INTO `attendance_bonus_config` (`config_id`, `min_attendance_percentage`, `max_attendance_percentage`, `bonus_percentage`, `created_at`, `updated_at`) VALUES
(1, '95.00', '100.00', '5.00', '2025-04-14 08:37:26', '2025-04-14 08:37:26'),
(2, '90.00', '94.99', '3.00', '2025-04-14 08:37:26', '2025-04-14 08:37:26'),
(3, '85.00', '89.99', '2.00', '2025-04-14 08:37:26', '2025-04-14 08:37:26'),
(4, '80.00', '84.99', '1.00', '2025-04-14 08:37:26', '2025-04-14 08:37:26');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_notifications`
--

CREATE TABLE `attendance_notifications` (
  `notification_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `notification_type` enum('check_in_reminder','check_out_reminder','absent_notification') NOT NULL,
  `notification_date` date NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attendance_notifications`
--

INSERT INTO `attendance_notifications` (`notification_id`, `emp_id`, `notification_type`, `notification_date`, `is_read`, `created_at`) VALUES
(1, 5, '', '2025-04-23', 0, '2025-04-23 08:38:59'),
(2, 5, '', '2025-04-23', 0, '2025-04-23 08:39:11'),
(6, 3, '', '2025-04-24', 0, '2025-04-24 07:23:36'),
(7, 3, '', '2025-04-24', 0, '2025-04-24 07:40:39'),
(8, 5, '', '2025-04-24', 0, '2025-04-24 07:45:27'),
(13, 5, '', '2025-04-25', 0, '2025-04-25 15:16:53'),
(14, 3, '', '2025-04-25', 0, '2025-04-25 15:17:46'),
(15, 5, '', '2025-05-02', 0, '2025-05-02 16:40:51'),
(16, 5, '', '2025-05-27', 0, '2025-05-27 19:42:19'),
(17, 5, '', '2025-05-27', 0, '2025-05-27 20:09:43'),
(18, 5, '', '2025-05-28', 0, '2025-05-28 02:47:25'),
(19, 3, '', '2025-05-28', 0, '2025-05-28 17:37:26'),
(20, 3, '', '2025-05-28', 0, '2025-05-28 18:08:19'),
(21, 3, '', '2025-05-28', 0, '2025-05-28 18:09:09'),
(22, 3, '', '2025-05-28', 0, '2025-05-28 18:09:29'),
(23, 3, '', '2025-05-28', 0, '2025-05-28 18:10:05'),
(24, 3, '', '2025-05-29', 0, '2025-05-29 02:49:13'),
(25, 3, '', '2025-05-31', 0, '2025-05-31 03:38:39'),
(26, 3, '', '2025-06-05', 0, '2025-06-05 18:43:20'),
(27, 3, '', '2025-06-05', 0, '2025-06-05 18:43:34'),
(28, 5, '', '2025-06-13', 0, '2025-06-13 18:09:47'),
(30, 3, '', '2025-06-25', 0, '2025-06-25 12:01:17'),
(31, 5, '', '2025-06-25', 0, '2025-06-25 13:38:58'),
(32, 5, '', '2025-06-25', 0, '2025-06-25 13:39:31'),
(33, 45, '', '2025-06-26', 0, '2025-06-26 14:36:23'),
(34, 45, '', '2025-06-26', 0, '2025-06-26 14:37:03');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_performance`
--

CREATE TABLE `attendance_performance` (
  `performance_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `total_working_days` int(11) NOT NULL,
  `days_present` int(11) NOT NULL,
  `days_late` int(11) NOT NULL,
  `days_absent` int(11) NOT NULL,
  `days_half_day` int(11) NOT NULL,
  `attendance_percentage` decimal(5,2) NOT NULL,
  `bonus_percentage` decimal(5,2) NOT NULL,
  `bonus_amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `attendance_performance`
--

INSERT INTO `attendance_performance` (`performance_id`, `emp_id`, `month`, `year`, `total_working_days`, `days_present`, `days_late`, `days_absent`, `days_half_day`, `attendance_percentage`, `bonus_percentage`, `bonus_amount`, `created_at`, `updated_at`) VALUES
(1, 3, 4, 2025, 22, 2, 1, 0, 0, '9.09', '0.00', '0.00', '2025-04-14 08:48:39', '2025-04-14 08:48:39'),
(2, 5, 4, 2025, 22, 1, 0, 0, 0, '4.55', '0.00', '0.00', '2025-04-15 06:29:37', '2025-04-15 06:29:37');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_policy`
--

CREATE TABLE `attendance_policy` (
  `policy_id` int(11) NOT NULL,
  `min_hours_present` decimal(4,2) NOT NULL DEFAULT '8.00',
  `min_hours_late` decimal(4,2) NOT NULL DEFAULT '5.00',
  `grace_period_minutes` int(11) NOT NULL DEFAULT '15',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `attendance_reports`
--

CREATE TABLE `attendance_reports` (
  `report_id` int(11) NOT NULL,
  `report_type` enum('daily','monthly','department','employee') NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `department_id` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `report_data` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `subject` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `name`, `email`, `subject`, `message`, `created_at`) VALUES
(12, 'abakar', 'abakardj26@gmail.com', 'touch', 'wjl wjbw jwbjwbjbwjl f', '2025-06-05 20:38:48'),
(13, 'abubakar', 'bargaltwo@gmail.com', 'touch', 'ek w e hk shjsg kskgkjw', '2025-06-05 20:42:28'),
(14, 'wbwke', 'obtainjob11@gmail.com', 'touch', 'uryufy fjfjhkfhfjkf', '2025-06-06 03:12:54'),
(15, 'abubakar', 'abakardj26@gmail.com', 'hjfhf', 'hjfhjfjh', '2025-06-10 20:06:31'),
(16, 'abubakar', 'bargaltwo@gmail.com', 'ejkne', 'hfhbfghj fgb', '2025-06-10 20:14:01'),
(17, 'ihgk', 'abakardj26@gmail.com', 'gkgj', 'jkngkgnjm', '2025-06-10 20:21:38'),
(18, 'ihgk', 'abakardj26@gmail.com', 'gkgj', 'jkngkgnjm', '2025-06-10 21:38:30'),
(19, 'abubakar', 'abakardj26@gmail.com', 'touch', 'bjbjbj jbbj', '2025-06-10 21:38:42'),
(20, 'abubakar', 'abakardj26@gmail.com', 'touch', 'ebwjlhwjh jvjhtkw', '2025-06-13 18:24:43'),
(21, '??????? ?????????', 'kingofsomalia00@gmail.com', 'ciidu fitri', 'fgfbjf j fg fjf jfjk fj', '2025-06-25 07:21:12'),
(22, '??????? ?????????', 'kingofsomalia00@gmail.com', 'ciidu fitri', 'ybfu fu fh fh jv j jhh', '2025-06-25 07:22:00'),
(23, 'dgfdgdjgdj', 'kingofsomalia00@gmail.com', 'ciidu fitri', 'jghfjgbefjg', '2025-06-25 14:27:46'),
(24, '??????? ?????????', 'ali@gmail.com', 'wjgkwgj', 'wkjgkjncgkjw', '2025-06-26 14:40:38'),
(25, '??????? ?????????', 'ali@gmail.com', 'wjgkwgj', 'wkjgkjncgkjw', '2025-06-26 14:45:20');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `dept_head` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`, `dept_head`, `created_at`) VALUES
(1, 'Information Technology', 9, '2025-04-11 03:32:24'),
(16, 'Operation', 39, '2025-06-23 22:10:03'),
(22, 'HR', 65, '2025-06-25 18:05:15'),
(23, 'hhhhhhhhhhhh', 63, '2025-06-26 06:41:49');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `emp_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `basic_salary` decimal(10,2) DEFAULT '0.00',
  `salary` decimal(10,2) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `profile_image` varchar(255) DEFAULT NULL,
  `gender` enum('male','female') NOT NULL DEFAULT 'male'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`emp_id`, `user_id`, `first_name`, `last_name`, `dept_id`, `position`, `hire_date`, `basic_salary`, `salary`, `phone`, `address`, `profile_image`, `gender`) VALUES
(3, 4, 'saalax', 'abdi', 1, 'ui designer', '2025-04-11', '500.00', '1000.00', '0615855900', 'kismayo-somalia', 'employee_4_1746427062.png', 'male'),
(5, 9, 'aden', 'mohamed', 1, 'manager', '2025-04-14', '2000.00', '1000.00', '0618726609', 'kismayo-somalia', 'manager_9_1746776043.jpeg', 'male'),
(27, 39, 'Ali ', 'Abdikarim', 16, NULL, '2025-06-24', '400.00', NULL, '0613147035', NULL, NULL, 'male'),
(28, 40, 'Abdirahman', 'Deck', 16, 'Developer', '2025-06-25', '300.00', NULL, '344674367437', 'kis', NULL, 'male'),
(38, 52, 'ugwow', 'bjwk', NULL, 'kwgjw', '2025-06-25', '500.00', NULL, '0613147035', 'Calanley-kismayo', NULL, 'female'),
(39, 53, 'khghkg', 'vkhkv', 16, 'ui designer', '2025-06-25', '777.00', NULL, '0618726609', 'Calanley-kismayo', NULL, 'male'),
(40, 54, '???????', '?????????', NULL, NULL, '2025-06-25', '8698.00', NULL, '0614594309', NULL, NULL, 'male'),
(41, 55, 'najiip', 'hassan', NULL, NULL, '2025-06-25', '1.00', NULL, '5643678643', NULL, NULL, 'male'),
(42, 57, 'ghhhhjj', 'hhhh', 22, 'ui designer', '2025-06-25', '1.00', NULL, '6575435678', 'Calanley-kismayo', NULL, 'male'),
(43, 61, 'sadam', 'ali', NULL, NULL, '2025-06-25', '100.00', NULL, '1234567890', NULL, NULL, 'male'),
(44, 62, 'asad', 'ali', 22, '1', '2025-06-25', '50.00', NULL, '2345666669', 'guulwade', NULL, 'male'),
(45, 63, 'abdi', 'dek', 23, NULL, '2025-06-25', '1111.00', NULL, '0618726609', NULL, NULL, 'male'),
(46, 65, 'yusuf', 'abdi', 22, NULL, '2025-06-25', '1111.00', NULL, '0614594309', NULL, NULL, 'male');

-- --------------------------------------------------------

--
-- Table structure for table `employee_leave_balance`
--

CREATE TABLE `employee_leave_balance` (
  `balance_id` int(11) NOT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `leave_type_id` int(11) DEFAULT NULL,
  `total_leaves` int(11) DEFAULT '0',
  `used_leaves` int(11) DEFAULT '0',
  `year` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee_leave_balance`
--

INSERT INTO `employee_leave_balance` (`balance_id`, `emp_id`, `leave_type_id`, `total_leaves`, `used_leaves`, `year`) VALUES
(1, 3, 1, 0, 5, 2025),
(3, 27, 1, 0, 2, 2025);

-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `leave_id` int(11) NOT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `requested_by_role` enum('employee','manager') NOT NULL DEFAULT 'employee',
  `leave_type_id` int(11) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `reason` text,
  `admin_remarks` text,
  `approved_by` int(11) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leave_requests`
--

INSERT INTO `leave_requests` (`leave_id`, `emp_id`, `requested_by_role`, `leave_type_id`, `start_date`, `end_date`, `status`, `reason`, `admin_remarks`, `approved_by`, `approved_at`, `created_at`) VALUES
(1, 3, 'employee', 1, '2025-04-15', '2025-04-16', 'approved', 'hjfyuhjvj yfjtiu', 'okay!!', 1, NULL, '2025-04-14 07:55:30'),
(3, 3, 'employee', 3, '2025-04-26', '2025-04-27', '', 'PERSONAL', NULL, NULL, NULL, '2025-04-26 07:13:01'),
(5, 5, 'manager', 6, '2025-05-10', '2025-05-24', '', 'sick', NULL, NULL, NULL, '2025-05-09 13:46:32'),
(7, 3, 'employee', 6, '2025-05-28', '2025-05-29', '', 'jdkdd', NULL, NULL, NULL, '2025-05-28 18:16:01'),
(11, 3, 'employee', 1, '2025-05-01', '2025-06-25', 'approved', 'fasax', 'ok', 9, '2025-06-25 17:31:23', '2025-06-25 14:24:14'),
(12, 3, 'employee', 1, '2025-06-25', '2025-06-27', '', 'f', NULL, NULL, NULL, '2025-06-25 16:21:12'),
(13, 3, 'employee', 1, '2025-06-25', '2025-06-27', 'approved', 'dd', 'ok', 9, '2025-06-25 19:31:13', '2025-06-25 16:30:37'),
(14, 3, 'employee', 1, '2025-06-25', '2025-06-26', '', 'f', NULL, NULL, NULL, '2025-06-25 16:32:06'),
(15, 27, 'manager', 1, '2025-06-25', '2025-06-26', 'approved', 'f', 'jf', 1, NULL, '2025-06-25 17:34:41');

-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `leave_types` (
  `leave_type_id` int(11) NOT NULL,
  `leave_type_name` varchar(50) NOT NULL,
  `description` text,
  `default_days` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `leave_types`
--

INSERT INTO `leave_types` (`leave_type_id`, `leave_type_name`, `description`, `default_days`) VALUES
(1, 'Annual Leave', 'Yearly vacation leave', 7),
(2, 'Sick Leave', 'Medical and health-related leave', 5),
(3, 'Personal Leave', 'Leave for personal matters', 5),
(6, 'Bereavement Leave', 'Leave for family death', 3);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `type`, `message`, `reference_id`, `is_read`, `created_at`) VALUES
(6, 4, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 7, 0, '2025-04-30 05:18:28'),
(9, 4, 'project_update', 'Project \"uaz\" status updated to: completed by manager', 7, 0, '2025-05-03 04:59:20'),
(12, 4, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 7, 0, '2025-05-04 06:54:21'),
(15, 4, 'project_update', 'Project \"uaz\" status updated to: completed by manager', 7, 0, '2025-05-04 06:54:45'),
(18, 4, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 7, 0, '2025-05-04 06:54:54'),
(21, 4, 'project_update', 'Project \"uaz\" status updated to: completed by manager', 7, 0, '2025-05-04 06:55:06'),
(50, 4, 'project_update', 'Project \"uaz\" status updated to: completed by manager', 7, 0, '2025-06-13 18:24:09'),
(99, 62, 'project_assignment', 'You have been assigned to project: uaz', 31, 0, '2025-06-26 13:15:35'),
(100, 63, 'project_assignment', 'You have been assigned as manager for project: uaz', 31, 0, '2025-06-26 13:15:35'),
(101, 57, 'project_assignment', 'You have been assigned to project: desing', 33, 0, '2025-06-26 13:56:01'),
(102, 53, 'project_assignment', 'You have been assigned to project: desing', 33, 0, '2025-06-26 13:56:01'),
(103, 9, 'project_assignment', 'You have been assigned as manager for project: desing', 33, 0, '2025-06-26 13:56:01'),
(104, 39, 'project_assignment', 'You have been assigned as manager for project: desing', 33, 0, '2025-06-26 14:05:18'),
(105, 62, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 31, 0, '2025-06-26 14:14:38'),
(106, 62, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 31, 0, '2025-06-26 14:14:55'),
(107, 62, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 31, 0, '2025-06-26 14:14:58'),
(108, 62, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 31, 0, '2025-06-26 14:19:40'),
(109, 62, 'project_update', 'Project \"uaz\" status updated to: not_started by manager', 31, 0, '2025-06-26 14:19:48'),
(110, 62, 'project_update', 'Project \"uaz\" status updated to: completed by manager', 31, 0, '2025-06-26 14:19:55'),
(111, 62, 'project_update', 'Project \"uaz\" status updated to: in_progress by manager', 31, 0, '2025-06-26 14:20:02'),
(112, 9, 'project_assignment', 'You have been assigned as manager for project: desing', 33, 0, '2025-06-26 14:29:57');

-- --------------------------------------------------------

--
-- Table structure for table `notification_types`
--

CREATE TABLE `notification_types` (
  `type_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `icon_class` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notification_types`
--

INSERT INTO `notification_types` (`type_id`, `type`, `title`, `icon_class`, `created_at`) VALUES
(1, 'project_assignment', 'Project Assignment', 'fas fa-tasks', '2025-06-06 19:42:37'),
(2, 'leave_approval', 'Leave Approval', 'fas fa-calendar-check', '2025-06-06 19:42:37'),
(3, 'attendance_reminder', 'Attendance Reminder', 'fas fa-clock', '2025-06-06 19:42:37'),
(4, 'salary_payment', 'Salary Payment', 'fas fa-money-bill', '2025-06-06 19:42:37'),
(5, 'task_deadline', 'Task Deadline', 'fas fa-calendar-alt', '2025-06-06 19:42:37');

-- --------------------------------------------------------

--
-- Table structure for table `payroll`
--

CREATE TABLE `payroll` (
  `payroll_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `basic_salary` decimal(10,2) NOT NULL,
  `gross_salary` decimal(10,2) NOT NULL DEFAULT '0.00',
  `net_salary` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('draft','approved','paid','cancelled') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payroll`
--

INSERT INTO `payroll` (`payroll_id`, `employee_id`, `period_id`, `basic_salary`, `gross_salary`, `net_salary`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 1, '500.00', '500.00', '500.00', 'paid', '2025-04-14 08:48:39', '2025-04-15 06:40:52'),
(3, 5, 3, '1000.00', '1000.00', '1000.00', 'paid', '2025-04-15 06:29:37', '2025-04-15 06:34:24'),
(4, 3, 4, '500.00', '500.00', '500.00', 'paid', '2025-04-21 16:04:16', '2025-04-21 16:04:32'),
(5, 3, 5, '500.00', '500.00', '500.00', 'paid', '2025-05-02 15:56:21', '2025-05-02 16:11:34'),
(16, 5, 16, '1000.00', '1000.00', '1000.00', 'paid', '2025-06-22 16:15:01', '2025-06-22 16:15:11'),
(17, 28, 17, '300.00', '300.00', '300.00', 'paid', '2025-06-25 11:46:18', '2025-06-25 11:46:30'),
(19, 45, 19, '1111.00', '1111.00', '1111.00', 'cancelled', '2025-06-26 07:04:39', '2025-06-26 07:05:15'),
(20, 45, 20, '1111.00', '1111.00', '1111.00', 'cancelled', '2025-06-26 07:05:23', '2025-06-26 07:05:35'),
(21, 3, 21, '500.00', '500.00', '500.00', 'cancelled', '2025-06-26 07:05:50', '2025-06-26 07:06:11'),
(22, 3, 22, '500.00', '500.00', '500.00', 'paid', '2025-06-26 07:06:31', '2025-06-26 07:06:49'),
(23, 45, 23, '1111.00', '1111.00', '1111.00', 'cancelled', '2025-06-26 07:23:20', '2025-06-26 07:23:36'),
(24, 39, 24, '777.00', '777.00', '777.00', 'cancelled', '2025-06-26 13:16:00', '2025-06-26 13:16:25');

-- --------------------------------------------------------

--
-- Table structure for table `payroll_adjustments`
--

CREATE TABLE `payroll_adjustments` (
  `adjustment_id` int(11) NOT NULL,
  `payroll_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `adjustment_type` enum('bonus','overtime','advance','loan','other') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `approved_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payroll_config`
--

CREATE TABLE `payroll_config` (
  `config_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payroll_config`
--

INSERT INTO `payroll_config` (`config_id`, `created_at`, `updated_at`) VALUES
(1, '2025-04-11 02:59:45', '2025-04-11 02:59:45');

-- --------------------------------------------------------

--
-- Table structure for table `payroll_periods`
--

CREATE TABLE `payroll_periods` (
  `period_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('draft','processing','completed','cancelled') DEFAULT 'draft',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payroll_periods`
--

INSERT INTO `payroll_periods` (`period_id`, `start_date`, `end_date`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(1, '2025-04-01', '2025-04-30', 'draft', 1, '2025-04-14 08:48:39', '2025-04-14 08:48:39'),
(2, '2025-04-01', '2025-04-30', 'draft', 1, '2025-04-15 06:10:37', '2025-04-15 06:10:37'),
(3, '2025-04-01', '2025-04-30', 'draft', 1, '2025-04-15 06:29:37', '2025-04-15 06:29:37'),
(4, '2025-04-01', '2025-04-30', 'draft', 1, '2025-04-21 16:04:16', '2025-04-21 16:04:16'),
(5, '2025-05-01', '2025-05-31', 'draft', 1, '2025-05-02 15:56:21', '2025-05-02 15:56:21'),
(6, '2025-04-01', '2025-04-30', 'draft', 1, '2025-05-02 16:05:32', '2025-05-02 16:05:32'),
(7, '2025-04-01', '2025-04-30', 'draft', 1, '2025-05-02 16:10:46', '2025-05-02 16:10:46'),
(8, '2025-04-01', '2025-04-30', 'draft', 1, '2025-05-03 05:18:43', '2025-05-03 05:18:43'),
(9, '2025-05-01', '2025-05-31', '', 1, '2025-05-03 05:19:06', '2025-05-03 05:20:27'),
(10, '2025-06-01', '2025-06-30', 'draft', 1, '2025-05-03 05:30:15', '2025-05-03 05:30:15'),
(11, '2025-05-01', '2025-05-31', '', 1, '2025-05-03 05:30:29', '2025-05-03 05:31:13'),
(12, '2025-05-01', '2025-05-31', '', 1, '2025-05-03 05:34:00', '2025-05-03 05:39:15'),
(13, '2025-06-01', '2025-06-30', '', 1, '2025-06-22 15:29:55', '2025-06-22 16:14:28'),
(14, '2025-06-01', '2025-06-30', '', 1, '2025-06-22 15:36:08', '2025-06-22 16:14:18'),
(15, '2025-06-01', '2025-06-30', '', 1, '2025-06-22 15:36:28', '2025-06-22 15:36:32'),
(16, '2025-06-01', '2025-06-30', '', 1, '2025-06-22 16:15:01', '2025-06-22 16:15:11'),
(17, '2025-06-01', '2025-06-30', '', 1, '2025-06-25 11:46:18', '2025-06-25 11:46:30'),
(18, '2025-08-01', '2025-08-31', 'draft', 1, '2025-06-25 11:47:24', '2025-06-25 11:47:24'),
(19, '2025-06-01', '2025-06-30', 'draft', 1, '2025-06-26 07:04:39', '2025-06-26 07:04:39'),
(20, '2025-06-01', '2025-06-30', 'draft', 1, '2025-06-26 07:05:23', '2025-06-26 07:05:23'),
(21, '2025-06-01', '2025-06-30', 'draft', 1, '2025-06-26 07:05:50', '2025-06-26 07:05:50'),
(22, '2025-06-01', '2025-06-30', '', 1, '2025-06-26 07:06:31', '2025-06-26 07:06:49'),
(23, '2025-06-01', '2025-06-30', 'draft', 1, '2025-06-26 07:23:20', '2025-06-26 07:23:20'),
(24, '2025-06-01', '2025-06-30', 'draft', 1, '2025-06-26 13:16:00', '2025-06-26 13:16:00');

-- --------------------------------------------------------

--
-- Table structure for table `payslips`
--

CREATE TABLE `payslips` (
  `payslip_id` int(11) NOT NULL,
  `payroll_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `generated_by` int(11) NOT NULL,
  `generated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('generated','downloaded','cancelled') DEFAULT 'generated'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `profile`
--

CREATE TABLE `profile` (
  `profile_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('admin','hr','manager','employee') NOT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `basic_salary` decimal(10,2) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `bio` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `profile`
--

INSERT INTO `profile` (`profile_id`, `user_id`, `username`, `email`, `role`, `status`, `first_name`, `last_name`, `dept_id`, `position`, `hire_date`, `basic_salary`, `salary`, `gender`, `profile_image`, `phone`, `address`, `bio`, `created_at`, `updated_at`) VALUES
(1, 1, 'admin', 'admin@example.com', 'admin', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-28 03:04:51', '2025-05-28 03:04:51'),
(2, 4, 'usame', 'usame@gmail.com', 'employee', 'active', 'usame', 'abdiwahab', 1, 'developer', '2025-04-11', '500.00', '1000.00', '', 'employee_4_1746427062.png', '0614594306', 'kismayo-somalia', NULL, '2025-05-28 03:04:51', '2025-05-28 03:04:51'),
(4, 9, 'aden', 'aden@gmail.com', 'manager', 'active', 'aden', 'ismacil', 1, 'manager', '2025-04-14', '1000.00', '1000.00', '', 'manager_9_1746776043.jpeg', '0618726609', 'kismayo-somalia', NULL, '2025-05-28 03:04:51', '2025-05-28 03:04:51');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `project_id` int(11) NOT NULL,
  `project_name` varchar(100) NOT NULL,
  `description` text,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('not_started','in_progress','completed','on_hold') DEFAULT 'not_started',
  `manager_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`project_id`, `project_name`, `description`, `start_date`, `end_date`, `status`, `manager_id`, `created_at`, `updated_at`) VALUES
(31, 'uaz', 'bjjj', '2025-06-26', '2025-06-28', 'in_progress', 45, '2025-06-26 13:15:34', '2025-06-26 14:20:02'),
(33, 'desing', 'bbjbk', '2025-06-26', '2025-06-28', 'in_progress', 5, '2025-06-26 13:56:01', '2025-06-26 14:29:57');

-- --------------------------------------------------------

--
-- Table structure for table `project_assignments`
--

CREATE TABLE `project_assignments` (
  `assignment_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `assigned_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `project_assignments`
--

INSERT INTO `project_assignments` (`assignment_id`, `project_id`, `emp_id`, `assigned_date`, `created_at`) VALUES
(49, 31, 44, '2025-06-26', '2025-06-26 13:15:34'),
(58, 33, 39, '2025-06-26', '2025-06-26 14:29:57'),
(59, 33, 42, '2025-06-26', '2025-06-26 14:29:57');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `setting_id` int(11) NOT NULL,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`setting_id`, `setting_key`, `setting_value`, `created_at`, `updated_at`) VALUES
(1, 'company_name', 'Naallo', '2025-04-11 02:59:45', '2025-06-25 11:59:33'),
(2, 'company_email', 'faarisfun@gmail.com', '2025-04-11 02:59:45', '2025-06-10 20:10:45'),
(3, 'company_address', 'kismayo-somalia', '2025-04-11 02:59:45', '2025-04-22 06:30:13'),
(4, 'work_hours', '8', '2025-04-11 02:59:45', '2025-04-11 02:59:45'),
(5, 'late_threshold', '15', '2025-04-11 02:59:45', '2025-04-11 02:59:45'),
(26, 'company_phone', '+252615905477', '2025-05-29 19:38:55', '2025-05-29 19:39:38'),
(45, 'company_logo', 'company_logo_1749093730.jpg', '2025-06-05 03:11:26', '2025-06-05 03:22:10');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('admin','hr','manager','employee') NOT NULL,
  `status` enum('active','inactive','on_leave','deleted') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `reset_token` varchar(64) DEFAULT NULL,
  `reset_token_expires` datetime DEFAULT NULL,
  `reset_code` varchar(6) DEFAULT NULL,
  `reset_code_expires` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `role`, `status`, `created_at`, `last_login`, `reset_token`, `reset_token_expires`, `reset_code`, `reset_code_expires`) VALUES
(1, 'admin', '$2y$10$eKcVucTDlJkGRa3C88bJGO5LUIz5I1MZx62mA4lXZvdP8WR0yqT9u', 'faarisfun@gmail.com', 'admin', 'active', '2025-04-11 02:59:45', '2025-06-26 14:38:46', 'be91d29501201bd940505634731b0f33fb810914ce3323778b35f4375f2e12fb', '2025-06-25 16:33:48', NULL, NULL),
(4, 'usame', '$2y$10$di1tW.svFcuG3ufg5SPseu048bySuqCQI7jC4dMA5Ep0aQHWZeNVC', 'kingofsomalia00@gmail.com', 'employee', 'active', '2025-04-11 03:35:48', '2025-06-26 14:35:33', NULL, NULL, NULL, NULL),
(9, 'aden', '$2y$10$FG0tKRRxirbppwC7HTQMD.y70BDcmeUcTV8hM7fbCJfovC0SCsrRu', 'aden@gmail.com', 'manager', 'active', '2025-04-14 14:30:55', '2025-06-26 07:15:48', NULL, NULL, NULL, NULL),
(39, 'ali', '$2y$10$PUWa9RwwX/pFZNYbQ1OT3u73iEIuirrAKKjCBOsxNgHYBUYN6osHS', 'ali@gmail.com', 'manager', 'active', '2025-06-23 22:09:47', '2025-06-25 17:34:19', NULL, NULL, NULL, NULL),
(40, 'abdirahman', '$2y$10$WptI.YcD0H5/ryv89duNfu9gopJ2fTrwHCNCAVs8zEu.tfzxL.mUG', 'abi@gmail.com', 'employee', 'active', '2025-06-23 22:11:03', '2025-06-25 12:42:32', NULL, NULL, NULL, NULL),
(52, 'ug', '$2y$10$tqsUNLdvARIo7Ugmyb8TH.ARgEABpfpR1WvPbAlJM5NqavuF9wkr6', 'hjwvfhw@gmail.com', 'employee', 'deleted', '2025-06-25 07:56:19', NULL, NULL, NULL, NULL, NULL),
(53, 'rrrr', '$2y$10$8iGgsw0mxgBqIAS2xTe31u659gHHh60b73yRJtWqUF4keIO7OKjPS', 'rrr@gmail.com', 'employee', 'active', '2025-06-25 08:15:46', NULL, NULL, NULL, NULL, NULL),
(54, 'uuuu', '$2y$10$U1puZVmoxH5myv05AOsM0ug5CvrnZuoBsQVEScu7qhVSzq7Xc6T.S', 'ghgji@gmail.com', 'manager', 'deleted', '2025-06-25 08:18:15', NULL, NULL, NULL, NULL, NULL),
(55, 'najiip', '$2y$10$Kb05xZutXA2RMHK48a2yKei80eehv/MDVzbdcicDH1iCqx3F/PVUK', 'najiip@gmail.com', 'manager', 'active', '2025-06-25 11:30:20', NULL, NULL, NULL, NULL, NULL),
(57, 'aliabdi', '$2y$10$zucPcxOpbOAQFt9O8JjzwOYZpzOIUdYdsgEifcsQ/WBcVgliJOH1O', 'aliabdi@gmail.com', 'employee', 'active', '2025-06-25 11:37:06', NULL, NULL, NULL, NULL, NULL),
(61, 'sadam', '$2y$10$1wWdVgxqus1EWYd.Hoa21uRsjYg4aIBsBbUUj48xIjKqK5AXuaWTK', 'sadamali@gmail.com', 'manager', 'active', '2025-06-25 12:19:18', NULL, NULL, NULL, NULL, NULL),
(62, 'asad', '$2y$10$71Kh9AwwNbs4Ig15LzpQFeAbtmKWGvSBMTrO.dqpNYUtOD4kUlyCe', 'asad@gmail.com', 'employee', 'active', '2025-06-25 12:21:41', '2025-06-26 14:22:20', NULL, NULL, NULL, NULL),
(63, 'abdi', '$2y$10$AfziRMczWHvSfa/T6VigD.HsHnT9MMblu4ooRtNAEjnw8vtX3mkkm', 'abdi@gmail.com', 'manager', 'active', '2025-06-25 18:01:29', '2025-06-26 14:36:16', NULL, NULL, NULL, NULL),
(65, 'yusu', '$2y$10$0Y1YVl3XSkSmahA2VL3Zousl7gd0Wn/Z7EnRJLDfIp.Al3vqerACa', 'uf@gmail.com', 'manager', 'active', '2025-06-25 18:05:06', NULL, NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- Indexes for table `attendance_bonus_config`
--
ALTER TABLE `attendance_bonus_config`
  ADD PRIMARY KEY (`config_id`);

--
-- Indexes for table `attendance_notifications`
--
ALTER TABLE `attendance_notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- Indexes for table `attendance_performance`
--
ALTER TABLE `attendance_performance`
  ADD PRIMARY KEY (`performance_id`),
  ADD UNIQUE KEY `unique_emp_month_year` (`emp_id`,`month`,`year`);

--
-- Indexes for table `attendance_policy`
--
ALTER TABLE `attendance_policy`
  ADD PRIMARY KEY (`policy_id`);

--
-- Indexes for table `attendance_reports`
--
ALTER TABLE `attendance_reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD KEY `dept_head` (`dept_head`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`emp_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `dept_id` (`dept_id`);

--
-- Indexes for table `employee_leave_balance`
--
ALTER TABLE `employee_leave_balance`
  ADD PRIMARY KEY (`balance_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `leave_type_id` (`leave_type_id`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`leave_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `leave_type_id` (`leave_type_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_requested_by_role` (`requested_by_role`);

--
-- Indexes for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`leave_type_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notification_types`
--
ALTER TABLE `notification_types`
  ADD PRIMARY KEY (`type_id`);

--
-- Indexes for table `payroll`
--
ALTER TABLE `payroll`
  ADD PRIMARY KEY (`payroll_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `period_id` (`period_id`);

--
-- Indexes for table `payroll_adjustments`
--
ALTER TABLE `payroll_adjustments`
  ADD PRIMARY KEY (`adjustment_id`),
  ADD KEY `payroll_id` (`payroll_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `payroll_config`
--
ALTER TABLE `payroll_config`
  ADD PRIMARY KEY (`config_id`);

--
-- Indexes for table `payroll_periods`
--
ALTER TABLE `payroll_periods`
  ADD PRIMARY KEY (`period_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `payslips`
--
ALTER TABLE `payslips`
  ADD PRIMARY KEY (`payslip_id`),
  ADD KEY `payroll_id` (`payroll_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `period_id` (`period_id`),
  ADD KEY `generated_by` (`generated_by`);

--
-- Indexes for table `profile`
--
ALTER TABLE `profile`
  ADD PRIMARY KEY (`profile_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`project_id`),
  ADD KEY `manager_id` (`manager_id`);

--
-- Indexes for table `project_assignments`
--
ALTER TABLE `project_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `emp_id` (`emp_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;
--
-- AUTO_INCREMENT for table `attendance_bonus_config`
--
ALTER TABLE `attendance_bonus_config`
  MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `attendance_notifications`
--
ALTER TABLE `attendance_notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT for table `attendance_performance`
--
ALTER TABLE `attendance_performance`
  MODIFY `performance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `attendance_policy`
--
ALTER TABLE `attendance_policy`
  MODIFY `policy_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `attendance_reports`
--
ALTER TABLE `attendance_reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `emp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;
--
-- AUTO_INCREMENT for table `employee_leave_balance`
--
ALTER TABLE `employee_leave_balance`
  MODIFY `balance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `leave_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `leave_types`
--
ALTER TABLE `leave_types`
  MODIFY `leave_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;
--
-- AUTO_INCREMENT for table `notification_types`
--
ALTER TABLE `notification_types`
  MODIFY `type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `payroll`
--
ALTER TABLE `payroll`
  MODIFY `payroll_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT for table `payroll_adjustments`
--
ALTER TABLE `payroll_adjustments`
  MODIFY `adjustment_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `payroll_config`
--
ALTER TABLE `payroll_config`
  MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `payroll_periods`
--
ALTER TABLE `payroll_periods`
  MODIFY `period_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT for table `payslips`
--
ALTER TABLE `payslips`
  MODIFY `payslip_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `profile`
--
ALTER TABLE `profile`
  MODIFY `profile_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT for table `project_assignments`
--
ALTER TABLE `project_assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;
--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `setting_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`) ON DELETE CASCADE;

--
-- Constraints for table `attendance_notifications`
--
ALTER TABLE `attendance_notifications`
  ADD CONSTRAINT `attendance_notifications_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`) ON DELETE CASCADE;

--
-- Constraints for table `attendance_performance`
--
ALTER TABLE `attendance_performance`
  ADD CONSTRAINT `attendance_performance_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`) ON DELETE CASCADE;

--
-- Constraints for table `attendance_reports`
--
ALTER TABLE `attendance_reports`
  ADD CONSTRAINT `attendance_reports_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`dept_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `attendance_reports_ibfk_2` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `attendance_reports_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`dept_head`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`);

--
-- Constraints for table `employee_leave_balance`
--
ALTER TABLE `employee_leave_balance`
  ADD CONSTRAINT `employee_leave_balance_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `employee_leave_balance_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`leave_type_id`);

--
-- Constraints for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD CONSTRAINT `leave_requests_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `leave_requests_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`leave_type_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `leave_requests_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `payroll`
--
ALTER TABLE `payroll`
  ADD CONSTRAINT `payroll_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`emp_id`),
  ADD CONSTRAINT `payroll_ibfk_2` FOREIGN KEY (`period_id`) REFERENCES `payroll_periods` (`period_id`);

--
-- Constraints for table `payroll_adjustments`
--
ALTER TABLE `payroll_adjustments`
  ADD CONSTRAINT `payroll_adjustments_ibfk_1` FOREIGN KEY (`payroll_id`) REFERENCES `payroll` (`payroll_id`),
  ADD CONSTRAINT `payroll_adjustments_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`emp_id`),
  ADD CONSTRAINT `payroll_adjustments_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `payroll_periods`
--
ALTER TABLE `payroll_periods`
  ADD CONSTRAINT `payroll_periods_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `payslips`
--
ALTER TABLE `payslips`
  ADD CONSTRAINT `payslips_ibfk_1` FOREIGN KEY (`payroll_id`) REFERENCES `payroll` (`payroll_id`),
  ADD CONSTRAINT `payslips_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`emp_id`),
  ADD CONSTRAINT `payslips_ibfk_3` FOREIGN KEY (`period_id`) REFERENCES `payroll_periods` (`period_id`),
  ADD CONSTRAINT `payslips_ibfk_4` FOREIGN KEY (`generated_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `profile`
--
ALTER TABLE `profile`
  ADD CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`emp_id`) ON DELETE SET NULL;

--
-- Constraints for table `project_assignments`
--
ALTER TABLE `project_assignments`
  ADD CONSTRAINT `project_assignments_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `project_assignments_ibfk_2` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`emp_id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
