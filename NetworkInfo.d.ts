export namespace NetworkInfo {
  function getSSID(fallback: any): Promise<string | null>;
  function getBSSID(fallback: any): Promise<string | null>;
  function getBroadcast(fallback: any): Promise<string | null>;
  function getIPAddress(fallback: any): Promise<string | null>;
  function getIPV4Address(fallback: any): Promise<string | null>;
  function getSubnet(fallback: any): Promise<string | null>;
  function getGatewayIPAddress(fallback: any): Promise<string | null>;
  function getFrequency(fallback: any): Promise<number | null>;
}
