import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  AlertTriangle, 
  QrCode, 
  Search, 
  SlidersHorizontal,
  Printer
} from 'lucide-react';

interface InventoryItem {
  id: string;
  sku: string;
  name: string;
  type: 'RawMaterial' | 'SemiFinished' | 'FinishedGood';
  quantity: number;
  reorderLevel: number;
  unit: string;
  warehouse: string;
  shelf: string;
  cost: number;
}

export const Inventory: React.FC = () => {
  const [items, setItems] = useState<InventoryItem[]>([
    { id: '1', sku: 'RM-STEEL-001', name: 'High-Grade Steel Sheet', type: 'RawMaterial', quantity: 1200, reorderLevel: 500, unit: 'kg', warehouse: 'Warehouse A', shelf: 'A-12', cost: 12.50 },
    { id: '2', sku: 'RM-CHIP-005', name: 'Microprocessor Unit X1', type: 'RawMaterial', quantity: 350, reorderLevel: 100, unit: 'pcs', warehouse: 'Warehouse B', shelf: 'B-04', cost: 45.00 },
    { id: '3', sku: 'RM-COIL-012', name: 'Copper Winding Wire 0.8mm', type: 'RawMaterial', quantity: 150, reorderLevel: 200, unit: 'kg', warehouse: 'Warehouse A', shelf: 'A-02', cost: 18.00 }, // breach
    { id: '4', sku: 'SF-MOTOR-INS', name: 'Coiled Motor Stator Core', type: 'SemiFinished', quantity: 80, reorderLevel: 50, unit: 'pcs', warehouse: 'Warehouse A', shelf: 'Sub-C1', cost: 75.00 },
    { id: '5', sku: 'FG-MOTOR-100', name: 'Smart Brushless Motor V2', type: 'FinishedGood', quantity: 8, reorderLevel: 15, unit: 'pcs', warehouse: 'Warehouse A', shelf: 'Ship-1', cost: 250.00 }, // breach
    { id: '6', sku: 'FG-GRIP-400', name: 'Mini Robotic Grip Arm', type: 'FinishedGood', quantity: 45, reorderLevel: 10, unit: 'pcs', warehouse: 'Warehouse C', shelf: 'Ship-2', cost: 185.00 },
  ]);

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedWarehouse, setSelectedWarehouse] = useState('All');
  const [selectedType, setSelectedType] = useState('All');
  const [selectedBarcodeItem, setSelectedBarcodeItem] = useState<InventoryItem | null>(null);
  const [isAdjustingStock, setIsAdjustingStock] = useState(false);
  const [adjustItem, setAdjustItem] = useState<InventoryItem | null>(null);
  const [adjustAmount, setAdjustAmount] = useState<number>(0);

  const warehouses = ['All', 'Warehouse A', 'Warehouse B', 'Warehouse C'];
  const types = ['All', 'RawMaterial', 'SemiFinished', 'FinishedGood'];

  const handleAdjustStock = () => {
    if (!adjustItem) return;
    setItems(prev => prev.map(item => {
      if (item.id === adjustItem.id) {
        return { ...item, quantity: Math.max(item.quantity + adjustAmount, 0) };
      }
      return item;
    }));
    setIsAdjustingStock(false);
    setAdjustItem(null);
    setAdjustAmount(0);
  };

  const filteredItems = items.filter(item => {
    const matchesSearch = item.name.toLowerCase().includes(searchQuery.toLowerCase()) || item.sku.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesWarehouse = selectedWarehouse === 'All' || item.warehouse === selectedWarehouse;
    const matchesType = selectedType === 'All' || item.type === selectedType;
    return matchesSearch && matchesWarehouse && matchesType;
  });

  const safetyBreaches = items.filter(item => item.quantity <= item.reorderLevel);

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">Inventory & Warehouse</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-1">Real-time stock balance ledger, reorder predictors, and QR barcode labels.</p>
        </div>

        <div className="flex gap-2">
          <button className="bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-300 text-xs font-bold px-4 py-2.5 rounded-xl hover:bg-slate-200 transition-all flex items-center gap-2">
            <SlidersHorizontal className="w-4 h-4" />
            Filters
          </button>
        </div>
      </div>

      {/* Safety Level Breach Warnings */}
      {safetyBreaches.length > 0 && (
        <div className="bg-rose-50/50 dark:bg-rose-950/20 border border-rose-200/50 dark:border-rose-900/30 p-4 rounded-2xl flex flex-col gap-3">
          <div className="flex items-center gap-2.5 text-rose-700 dark:text-rose-400">
            <AlertTriangle className="w-5 h-5" />
            <h4 className="text-sm font-bold">Safety Stock Level Breach Alerts</h4>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {safetyBreaches.map(item => (
              <div key={item.id} className="bg-white dark:bg-slate-900 border border-slate-200/50 dark:border-slate-800/80 p-3.5 rounded-xl flex justify-between items-center text-xs">
                <div>
                  <span className="font-mono text-[9px] text-slate-400 font-bold block">{item.sku}</span>
                  <span className="font-bold text-slate-700 dark:text-slate-300">{item.name}</span>
                </div>
                <div className="text-right">
                  <p className="text-rose-500 font-bold">{item.quantity} {item.unit} left</p>
                  <p className="text-[10px] text-slate-400">Buffer: {item.reorderLevel} {item.unit}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Main Stock Grid and Barcode Tool */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Stock Ledger table */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 lg:col-span-2 space-y-4">
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-3">
            <h3 className="font-bold text-slate-800 dark:text-white">Active Stock Balances</h3>
            
            {/* Filter selectors */}
            <div className="flex gap-2 flex-wrap">
              <select 
                value={selectedWarehouse}
                onChange={(e) => setSelectedWarehouse(e.target.value)}
                className="bg-slate-50 dark:bg-slate-800 border-0 rounded-lg text-xs font-bold px-2 py-1.5 focus:ring-1 focus:ring-blue-600"
              >
                {warehouses.map(w => <option key={w} value={w}>{w}</option>)}
              </select>
              <select 
                value={selectedType}
                onChange={(e) => setSelectedType(e.target.value)}
                className="bg-slate-50 dark:bg-slate-800 border-0 rounded-lg text-xs font-bold px-2 py-1.5 focus:ring-1 focus:ring-blue-600"
              >
                {types.map(t => <option key={t} value={t}>{t === 'All' ? 'All Types' : t}</option>)}
              </select>
            </div>
          </div>

          {/* Search bar */}
          <div className="relative">
            <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input 
              type="text" 
              placeholder="Search items by SKU, name, warehouse..." 
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 pl-9 pr-4 py-2 rounded-xl text-xs focus:outline-none focus:ring-1 focus:ring-blue-600"
            />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs whitespace-nowrap">
              <thead>
                <tr className="border-b border-slate-200 dark:border-slate-800 text-slate-400 font-bold uppercase tracking-wider">
                  <th className="pb-3">SKU</th>
                  <th className="pb-3">Name</th>
                  <th className="pb-3">Type</th>
                  <th className="pb-3 text-right">Available</th>
                  <th className="pb-3">Warehouse</th>
                  <th className="pb-3 text-center">Labels</th>
                  <th className="pb-3 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80">
                {filteredItems.map(item => {
                  const typeColors = {
                    RawMaterial: 'bg-blue-50 dark:bg-blue-950/20 text-blue-600 dark:text-blue-400 border-blue-200/50',
                    SemiFinished: 'bg-indigo-50 dark:bg-indigo-950/20 text-indigo-600 dark:text-indigo-400 border-indigo-200/50',
                    FinishedGood: 'bg-emerald-50 dark:bg-emerald-950/20 text-emerald-600 dark:text-emerald-400 border-emerald-200/50'
                  };

                  const isBreached = item.quantity <= item.reorderLevel;

                  return (
                    <tr key={item.id} className="text-slate-600 dark:text-slate-400 font-medium">
                      <td className="py-3.5 font-mono font-bold text-slate-800 dark:text-white">{item.sku}</td>
                      <td className="py-3.5 font-semibold text-slate-800 dark:text-slate-300">{item.name}</td>
                      <td className="py-3.5">
                        <span className={`px-2 py-0.5 border rounded-full text-[9px] font-bold ${typeColors[item.type]}`}>
                          {item.type}
                        </span>
                      </td>
                      <td className={`py-3.5 text-right font-bold ${isBreached ? 'text-rose-500' : 'text-slate-800 dark:text-white'}`}>
                        {item.quantity} {item.unit}
                      </td>
                      <td className="py-3.5 font-semibold text-slate-700 dark:text-slate-300">{item.warehouse} <span className="text-[10px] text-slate-400">({item.shelf})</span></td>
                      <td className="py-3.5 text-center">
                        <button 
                          onClick={() => setSelectedBarcodeItem(item)}
                          className="p-1.5 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg text-slate-400 hover:text-slate-800 dark:hover:text-white"
                          title="Generate QR code label"
                        >
                          <QrCode className="w-4 h-4" />
                        </button>
                      </td>
                      <td className="py-3.5 text-right">
                        <button 
                          onClick={() => {
                            setAdjustItem(item);
                            setIsAdjustingStock(true);
                          }}
                          className="text-[10px] font-bold text-blue-600 hover:underline"
                        >
                          Adjust Stock
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>

        {/* QR Code Barcode Card Simulator */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 flex flex-col justify-between h-96">
          <div className="space-y-4">
            <h3 className="font-bold text-slate-800 dark:text-white text-base">QR / Barcode Label Generator</h3>
            <p className="text-xs text-slate-400">Generates instant inventory bin location labels matching ERP records.</p>
          </div>

          {selectedBarcodeItem ? (
            <motion.div
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              className="bg-slate-50 dark:bg-slate-800/30 p-6 rounded-2xl border border-slate-200/60 dark:border-slate-800/60 flex flex-col items-center gap-4 relative"
            >
              {/* QR Image block */}
              <div className="w-24 h-24 bg-white border border-slate-200 p-2 rounded-xl flex items-center justify-center">
                <svg className="w-full h-full text-slate-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                </svg>
              </div>

              <div className="text-center">
                <span className="font-mono text-[9px] text-slate-400 font-extrabold block">{selectedBarcodeItem.sku}</span>
                <span className="font-bold text-slate-800 dark:text-white text-sm">{selectedBarcodeItem.name}</span>
                <span className="text-[10px] text-slate-500 font-medium block mt-1">Loc: {selectedBarcodeItem.warehouse} | Shelf: {selectedBarcodeItem.shelf}</span>
              </div>

              <button className="mt-2 text-xs font-bold text-blue-600 hover:text-blue-700 flex items-center gap-1.5 underline">
                <Printer className="w-3.5 h-3.5" />
                Print Label (Bin card)
              </button>
            </motion.div>
          ) : (
            <div className="border border-dashed border-slate-200 dark:border-slate-800 rounded-2xl flex-1 flex flex-col items-center justify-center p-6 text-center text-slate-400">
              <QrCode className="w-12 h-12 text-slate-300 mb-3" />
              <p className="text-xs font-bold">No product selected</p>
              <p className="text-[10px] mt-1 text-slate-400">Click the barcode icon next to an item in the stock table to preview its label.</p>
            </div>
          )}
        </div>
      </div>

      {/* Stock Adjustment Dialog */}
      <AnimatePresence>
        {isAdjustingStock && adjustItem && (
          <div className="fixed inset-0 bg-slate-950/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
            <motion.div
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-xl"
            >
              <h3 className="text-lg font-bold text-slate-800 dark:text-white">Adjust Stock: {adjustItem.name}</h3>
              <p className="text-xs text-slate-400 font-mono">SKU: {adjustItem.sku} | Current: {adjustItem.quantity} {adjustItem.unit}</p>

              <div className="space-y-3.5 pt-2">
                <div className="space-y-1.5">
                  <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider block">Quantity Offset (use negative to reduce)</label>
                  <input 
                    type="number"
                    value={adjustAmount}
                    onChange={(e) => setAdjustAmount(Number(e.target.value))}
                    className="w-full bg-slate-100 dark:bg-slate-800 border-0 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-600 focus:outline-none"
                  />
                </div>
              </div>

              <div className="flex justify-end gap-3 pt-2">
                <button 
                  onClick={() => setIsAdjustingStock(false)}
                  className="px-4 py-2 text-xs font-bold text-slate-400 hover:text-slate-600 transition-colors"
                >
                  Cancel
                </button>
                <button 
                  onClick={handleAdjustStock}
                  className="px-5 py-2.5 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md shadow-blue-500/20 transition-all"
                >
                  Submit Adjustment
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
};
