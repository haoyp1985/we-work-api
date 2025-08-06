/**
 * 日期时间工具函数
 */

/**
 * 格式化日期时间
 */
export function formatDateTime(
  date: string | number | Date,
  format: string = "YYYY-MM-DD HH:mm:ss",
): string {
  if (!date) return "";

  const d = new Date(date);
  if (isNaN(d.getTime())) return "";

  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  const hours = String(d.getHours()).padStart(2, "0");
  const minutes = String(d.getMinutes()).padStart(2, "0");
  const seconds = String(d.getSeconds()).padStart(2, "0");

  const replacements: Record<string, string> = {
    YYYY: year.toString(),
    MM: month,
    DD: day,
    HH: hours,
    mm: minutes,
    ss: seconds,
  };

  let result = format;
  for (const [pattern, replacement] of Object.entries(replacements)) {
    result = result.replace(new RegExp(pattern, "g"), replacement);
  }

  return result;
}

/**
 * 格式化日期
 */
export function formatDate(date: string | number | Date): string {
  return formatDateTime(date, "YYYY-MM-DD");
}

/**
 * 格式化时间
 */
export function formatTime(date: string | number | Date): string {
  return formatDateTime(date, "HH:mm:ss");
}

/**
 * 相对时间格式化（如：1分钟前、2小时前）
 */
export function formatRelativeTime(date: string | number | Date): string {
  if (!date) return "";

  const d = new Date(date);
  if (isNaN(d.getTime())) return "";

  const now = new Date();
  const diff = now.getTime() - d.getTime();

  if (diff < 0) return "未来时间";

  const seconds = Math.floor(diff / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);
  const months = Math.floor(days / 30);
  const years = Math.floor(months / 12);

  if (years > 0) return `${years}年前`;
  if (months > 0) return `${months}个月前`;
  if (days > 0) return `${days}天前`;
  if (hours > 0) return `${hours}小时前`;
  if (minutes > 0) return `${minutes}分钟前`;
  if (seconds > 30) return `${seconds}秒前`;
  return "刚刚";
}

/**
 * 获取日期范围
 */
export function getDateRange(
  type: "today" | "yesterday" | "week" | "month" | "quarter" | "year",
): [Date, Date] {
  const now = new Date();
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

  switch (type) {
    case "today":
      return [today, new Date(today.getTime() + 24 * 60 * 60 * 1000 - 1)];

    case "yesterday":
      const yesterday = new Date(today.getTime() - 24 * 60 * 60 * 1000);
      return [
        yesterday,
        new Date(yesterday.getTime() + 24 * 60 * 60 * 1000 - 1),
      ];

    case "week":
      const weekStart = new Date(today);
      weekStart.setDate(today.getDate() - today.getDay());
      const weekEnd = new Date(weekStart);
      weekEnd.setDate(weekStart.getDate() + 6);
      weekEnd.setHours(23, 59, 59, 999);
      return [weekStart, weekEnd];

    case "month":
      const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);
      const monthEnd = new Date(
        today.getFullYear(),
        today.getMonth() + 1,
        0,
        23,
        59,
        59,
        999,
      );
      return [monthStart, monthEnd];

    case "quarter":
      const quarterMonth = Math.floor(today.getMonth() / 3) * 3;
      const quarterStart = new Date(today.getFullYear(), quarterMonth, 1);
      const quarterEnd = new Date(
        today.getFullYear(),
        quarterMonth + 3,
        0,
        23,
        59,
        59,
        999,
      );
      return [quarterStart, quarterEnd];

    case "year":
      const yearStart = new Date(today.getFullYear(), 0, 1);
      const yearEnd = new Date(today.getFullYear(), 11, 31, 23, 59, 59, 999);
      return [yearStart, yearEnd];

    default:
      return [today, today];
  }
}

/**
 * 检查是否为同一天
 */
export function isSameDay(date1: Date, date2: Date): boolean {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  );
}

/**
 * 检查是否为今天
 */
export function isToday(date: Date): boolean {
  return isSameDay(date, new Date());
}

/**
 * 检查是否为昨天
 */
export function isYesterday(date: Date): boolean {
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  return isSameDay(date, yesterday);
}

/**
 * 获取两个日期之间的天数差
 */
export function getDaysBetween(date1: Date, date2: Date): number {
  const oneDay = 24 * 60 * 60 * 1000;
  return Math.round(Math.abs((date1.getTime() - date2.getTime()) / oneDay));
}

/**
 * 添加天数
 */
export function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

/**
 * 添加月份
 */
export function addMonths(date: Date, months: number): Date {
  const result = new Date(date);
  result.setMonth(result.getMonth() + months);
  return result;
}

/**
 * 获取月份的第一天
 */
export function getFirstDayOfMonth(date: Date): Date {
  return new Date(date.getFullYear(), date.getMonth(), 1);
}

/**
 * 获取月份的最后一天
 */
export function getLastDayOfMonth(date: Date): Date {
  return new Date(date.getFullYear(), date.getMonth() + 1, 0);
}
