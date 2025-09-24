-- (A) Tạo & chọn CSDL (không sao nếu đã tồn tại)
CREATE DATABASE IF NOT EXISTS company_progress
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE company_progress;

-- (B) Xóa các bảng theo thứ tự ngược phụ thuộc
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS BaoCao;
DROP TABLE IF EXISTS NhatKyCongViec;
DROP TABLE IF EXISTS CongViec;
DROP TABLE IF EXISTS ThanhVienDuAn;
DROP TABLE IF EXISTS DuAn;
DROP TABLE IF EXISTS NguoiDung;
SET FOREIGN_KEY_CHECKS = 1;

-- (C) Tạo lại bảng theo đúng thứ tự phụ thuộc

-- 1) NguoiDung
CREATE TABLE NguoiDung (
  UserID      INT AUTO_INCREMENT PRIMARY KEY,
  Username    VARCHAR(50)  NOT NULL UNIQUE,
  Password    VARCHAR(255) NOT NULL,
  FullName    VARCHAR(100),
  Email       VARCHAR(100),
  Phone       VARCHAR(20),
  Role        ENUM('Admin','PM','Employee','Director') DEFAULT 'Employee',
  Status      ENUM('Active','Inactive') DEFAULT 'Active',
  CreatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2) DuAn
CREATE TABLE DuAn (
  ProjectID   INT AUTO_INCREMENT PRIMARY KEY,
  ProjectName VARCHAR(100) NOT NULL,
  Description TEXT,
  StartDate   DATE,
  EndDate     DATE,
  Status      ENUM('Planning','In Progress','Completed','Closed') DEFAULT 'Planning',
  CreatedBy   INT,
  CreatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_duan_createdby (CreatedBy),
  CONSTRAINT fk_duan_createdby FOREIGN KEY (CreatedBy)
    REFERENCES NguoiDung(UserID)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3) ThanhVienDuAn (N–N)
CREATE TABLE ThanhVienDuAn (
  ProjectID     INT NOT NULL,
  UserID        INT NOT NULL,
  RoleInProject VARCHAR(50),
  PRIMARY KEY (ProjectID, UserID),
  INDEX idx_tvd_user (UserID),
  CONSTRAINT fk_tvd_project FOREIGN KEY (ProjectID)
    REFERENCES DuAn(ProjectID)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_tvd_user FOREIGN KEY (UserID)
    REFERENCES NguoiDung(UserID)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4) CongViec
CREATE TABLE CongViec (
  TaskID      INT AUTO_INCREMENT PRIMARY KEY,
  ProjectID   INT,
  TaskName    VARCHAR(100) NOT NULL,
  Description TEXT,
  AssignedTo  INT,
  StartDate   DATE,
  DueDate     DATE,
  Status      ENUM('Not Started','In Progress','Completed','Overdue') DEFAULT 'Not Started',
  Progress    INT DEFAULT 0, -- 0..100
  CreatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_cv_project (ProjectID),
  INDEX idx_cv_assigned (AssignedTo),
  CONSTRAINT fk_cv_project FOREIGN KEY (ProjectID)
    REFERENCES DuAn(ProjectID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_cv_assigned FOREIGN KEY (AssignedTo)
    REFERENCES NguoiDung(UserID)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5) NhatKyCongViec
CREATE TABLE NhatKyCongViec (
  LogID          INT AUTO_INCREMENT PRIMARY KEY,
  TaskID         INT,
  UserID         INT,
  WorkDate       DATE,
  ProgressUpdate TEXT,
  PercentDone    INT,
  CreatedAt      DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_nk_task (TaskID),
  INDEX idx_nk_user (UserID),
  CONSTRAINT fk_nk_task FOREIGN KEY (TaskID)
    REFERENCES CongViec(TaskID)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_nk_user FOREIGN KEY (UserID)
    REFERENCES NguoiDung(UserID)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6) BaoCao
CREATE TABLE BaoCao (
  ReportID       INT AUTO_INCREMENT PRIMARY KEY,
  ReportType     ENUM('Progress','Performance','Summary'),
  GeneratedBy    INT,
  GeneratedDate  DATETIME DEFAULT CURRENT_TIMESTAMP,
  Content        LONGTEXT,
  FilePath       VARCHAR(255),
  INDEX idx_bc_user (GeneratedBy),
  CONSTRAINT fk_bc_user FOREIGN KEY (GeneratedBy)
    REFERENCES NguoiDung(UserID)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




