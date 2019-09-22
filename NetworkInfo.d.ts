export namespace NetworkInfo {
  function getBSSID<T>(fallback?: T): Promise<string | T>;
  function getBroadcast<T>(fallback?: T): Promise<string | T>;
  function getIPAddress<T>(fallback?: T): Promise<string | T>;
  function getIPV4Address<T>(fallback?: T): Promise<string | T>;
}