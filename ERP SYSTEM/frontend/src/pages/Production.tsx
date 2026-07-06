import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  GitFork, 
  Layers, 
  Calendar, 
  Plus, 
  Search, 
  SlidersHorizontal,
  ChevronDown,
  ChevronUp,
  FileDown
} from 'lucide-react';

interface BOMItem {
  sku: string;
  name: string;
  qtyRequired: number;
  unit: string;
  cost: number;
}

interface BOMData {
  id: string;
  finishedGoodName: string;
  sku: string;
  version: string;
  isActive: boolean;
  routingSteps: string[];
  items: BOMItem[];
}

interface WorkOrder {
  id: string;
  orderNumber: string;
  bomSku: string;
  productName: string;
  targetQty: number;
  completedQty: number;
  scrapQty: number;
  status: 'Pending' | 'In Progress' | 'Completed';
  startDate: string;
  endDate: string;
}

export const Production: React.FC = () => {
  const [boms] = useState<BOMData[]>([
    {
      id: '1',
      finishedGoodName: 'Smart Brushless Motor V2',
      sku: 'FG-MOTOR-100',
      version: '2.1.0',
      isActive: true,
      routingSteps: ['Stator Winding', 'Rotor Pressing', 'Chassis CNC Assembly', 'Coil Insulation Test'],
      items: [
        { sku: 'RM-STEEL-001', name: 'High-Grade Steel Sheet', qtyRequired: 2.5, unit: 'kg', cost: 12.50 },
        { sku: 'RM-COIL-012', name: 'Copper Winding Wire 0.8mm', qtyRequired: 1.2, unit: 'kg', cost: 18.00 },
        { sku: 'RM-CHIP-005', name: 'Microprocessor Unit X1', qtyRequired: 1, unit: 'pcs', cost: 45.00 },
        { sku: 'RM-BRG-221', name: 'High-Speed Bearing 12mm', qtyRequired: 2, unit: 'pcs', cost: 5.50 },
      ]
    },
    {
      id: '2',
      finishedGoodName: 'Mini Robotic Grip Arm',
      sku: 'FG-GRIP-400',
      version: '1.0.4',
      isActive: true,
      routingSteps: ['Aluminium Laser Cutting', 'Servo Driver Mount', 'Logic Calibration'],
      items: [
        { sku: 'RM-ALUM-302', name: 'Aluminium Plate 5mm', qtyRequired: 1.8, unit: 'kg', cost: 15.00 },
        { sku: 'RM-SRV-902', name: 'Digital Servo Motor 20kg', qtyRequired: 3, unit: 'pcs', cost: 35.00 },
        { sku: 'RM-PCB-881', name: 'Relay Controller Board', qtyRequired: 1, unit: 'pcs', cost: 22.00 },
      ]
    }
  ]);

  const [workOrders, setWorkOrders] = useState<WorkOrder[]>([
    { id: '1', orderNumber: 'WO-2026-001', bomSku: 'FG-MOTOR-100', productName: 'Smart Brushless Motor V2', targetQty: 100, completedQty: 35, scrapQty: 2, status: 'In Progress', startDate: '2026-07-06', endDate: '2026-07-09' },
    { id: '2', orderNumber: 'WO-2026-002', bomSku: 'FG-GRIP-400', productName: 'Mini Robotic Grip Arm', targetQty: 50, completedQty: 0, scrapQty: 0, status: 'Pending', startDate: '2026-07-10', endDate: '2026-07-14' },
    { id: '3', orderNumber: 'WO-2026-003', bomSku: 'FG-MOTOR-100', productName: 'Smart Brushless Motor V2', targetQty: 200, completedQty: 200, scrapQty: 5, status: 'Completed', startDate: '2026-06-28', endDate: '2026-07-02' }
  ]);

  const [expandedBoms, setExpandedBoms] = useState<Record<string, boolean>>({ '1': true });
  const [isNewOrderModalOpen, setIsNewOrderModalOpen] = useState(false);
  const [selectedBOMForOrder, setSelectedBOMForOrder] = useState<string>('FG-MOTOR-100');
  const [newOrderQty, setNewOrderQty] = useState<number>(100);

  const toggleBom = (id: string) => {
    setExpandedBoms(prev => ({ ...prev, [id]: !prev[id] }));
  };

  const createWorkOrder = () => {
    const selectedBOM = boms.find(b => b.sku === selectedBOMForOrder);
    if (!selectedBOM) return;

    const newWO: WorkOrder = {
      id: String(workOrders.length + 1),
      orderNumber: `WO-2026-00${workOrders.length + 1}`,
      bomSku: selectedBOMForOrder,
      productName: selectedBOM.finishedGoodName,
      targetQty: newOrderQty,
      completedQty: 0,
      scrapQty: 0,
      status: 'Pending',
      startDate: new Date().toISOString().split('T')[0],
      endDate: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
    };

    setWorkOrders(prev => [newWO, ...prev]);
    setIsNewOrderModalOpen(false);
  };

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">Production Management</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-1">Configure Bills of Materials (BOM), schedule routings, and manage work orders.</p>
        </div>

        <button 
          onClick={() => setIsNewOrderModalOpen(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold px-4 py-2.5 rounded-xl shadow-md shadow-blue-500/20 transition-all flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Create Work Order
        </button>
      </div>

      {/* Bill of Materials Configuration Trees */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 space-y-6">
        <div className="flex justify-between items-center">
          <div className="flex items-center gap-2.5">
            <Layers className="w-5 h-5 text-blue-600" />
            <h3 className="font-bold text-slate-800 dark:text-white">Active Bills of Materials (BOM)</h3>
          </div>
          <span className="text-xs text-slate-400">2 active assemblies</span>
        </div>

        <div className="space-y-4">
          {boms.map((bom) => {
            const isExpanded = expandedBoms[bom.id];
            const totalCost = bom.items.reduce((acc, curr) => acc + (curr.cost * curr.qtyRequired), 0);

            return (
              <div key={bom.id} className="border border-slate-100 dark:border-slate-800 rounded-xl overflow-hidden">
                {/* Accordion Trigger */}
                <button 
                  onClick={() => toggleBom(bom.id)}
                  className="w-full flex items-center justify-between px-6 py-4 bg-slate-50/50 dark:bg-slate-800/20 hover:bg-slate-100/40 dark:hover:bg-slate-800/40 transition-colors text-left"
                >
                  <div className="flex items-center gap-4">
                    <GitFork className="w-5 h-5 text-slate-400" />
                    <div>
                      <h4 className="text-sm font-bold text-slate-800 dark:text-white">{bom.finishedGoodName}</h4>
                      <div className="flex items-center gap-2 mt-1">
                        <span className="font-mono text-[10px] text-slate-400">{bom.sku}</span>
                        <span className="text-[10px] font-bold bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 px-1.5 py-0.5 rounded">v{bom.version}</span>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center gap-6">
                    <div className="text-right text-xs">
                      <p className="text-slate-400">Total Material Cost</p>
                      <p className="font-extrabold text-slate-800 dark:text-white">₹{totalCost.toFixed(2)}</p>
                    </div>
                    {isExpanded ? <ChevronUp className="w-4 h-4 text-slate-400" /> : <ChevronDown className="w-4 h-4 text-slate-400" />}
                  </div>
                </button>

                {/* Extended Details Tree */}
                <AnimatePresence initial={false}>
                  {isExpanded && (
                    <motion.div
                      initial={{ height: 0 }}
                      animate={{ height: 'auto' }}
                      exit={{ height: 0 }}
                      className="overflow-hidden bg-white dark:bg-slate-900 border-t border-slate-100 dark:border-slate-800/60"
                    >
                      <div className="p-6 space-y-6">
                        {/* Routing Steps */}
                        <div className="space-y-2">
                          <span className="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest block">Assembly Routing Steps</span>
                          <div className="flex flex-wrap gap-2">
                            {bom.routingSteps.map((step, idx) => (
                              <div key={idx} className="flex items-center text-xs">
                                <span className="w-5 h-5 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400 flex items-center justify-center font-bold mr-1.5">{idx+1}</span>
                                <span className="font-semibold text-slate-600 dark:text-slate-400 mr-3">{step}</span>
                                {idx < bom.routingSteps.length - 1 && <span className="text-slate-300 dark:text-slate-700 mr-3">→</span>}
                              </div>
                            ))}
                          </div>
                        </div>

                        {/* BOM Component Table */}
                        <div className="space-y-2">
                          <span className="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest block">Components List</span>
                          <table className="w-full text-left text-xs">
                            <thead>
                              <tr className="border-b border-slate-100 dark:border-slate-800 text-slate-400 font-bold">
                                <th className="pb-2">Component SKU</th>
                                <th className="pb-2">Material Name</th>
                                <th className="pb-2">Qty Required</th>
                                <th className="pb-2 text-right">Unit Price</th>
                                <th className="pb-2 text-right">Line Cost</th>
                              </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-100 dark:divide-slate-800/50">
                              {bom.items.map((item, idx) => (
                                <tr key={idx} className="text-slate-600 dark:text-slate-400">
                                  <td className="py-2.5 font-mono text-[10px]">{item.sku}</td>
                                  <td className="py-2.5 font-semibold text-slate-700 dark:text-slate-300">{item.name}</td>
                                  <td className="py-2.5">{item.qtyRequired} {item.unit}</td>
                                  <td className="py-2.5 text-right">₹{item.cost.toFixed(2)}</td>
                                  <td className="py-2.5 text-right font-bold text-slate-800 dark:text-white">₹{(item.cost * item.qtyRequired).toFixed(2)}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            );
          })}
        </div>
      </div>

      {/* Work Orders Table */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow rounded-2xl p-6 space-y-4">
        <div className="flex justify-between items-center">
          <div>
            <h3 className="font-bold text-slate-800 dark:text-white text-base">Active Work Orders</h3>
            <p className="text-xs text-slate-400">Manufacturing orders tracked in real-time on the shop floor.</p>
          </div>
          
          <div className="flex gap-2">
            <button className="p-2 border border-slate-200 dark:border-slate-800 rounded-lg text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800">
              <SlidersHorizontal className="w-4 h-4" />
            </button>
            <button className="p-2 border border-slate-200 dark:border-slate-800 rounded-lg text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800 flex items-center gap-1.5 text-xs font-semibold">
              <FileDown className="w-4 h-4" />
              Export CSV
            </button>
          </div>
        </div>

        {/* Search */}
        <div className="relative">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input 
            type="text" 
            placeholder="Search work orders (e.g. SKU, Name, Order #)" 
            className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 pl-9 pr-4 py-2 rounded-xl text-xs focus:outline-none focus:ring-1 focus:ring-blue-600"
          />
        </div>

        {/* Table layout */}
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs whitespace-nowrap">
            <thead>
              <tr className="border-b border-slate-200 dark:border-slate-800 text-slate-400 font-extrabold uppercase tracking-wider">
                <th className="py-3">Order Number</th>
                <th className="py-3">Finished Good</th>
                <th className="py-3">BOM SKU</th>
                <th className="py-3 text-center">Output Progress</th>
                <th className="py-3 text-center">Scrap Units</th>
                <th className="py-3">Status</th>
                <th className="py-3">Dates</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800/80">
              {workOrders.map((wo) => {
                const percent = Math.min(Math.round((wo.completedQty / wo.targetQty) * 100), 100);
                
                const statusColors = {
                  'In Progress': 'bg-blue-50 dark:bg-blue-950/20 text-blue-600 dark:text-blue-400 border-blue-200/50',
                  'Pending': 'bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400 border-slate-200/40',
                  'Completed': 'bg-emerald-50 dark:bg-emerald-950/20 text-emerald-600 dark:text-emerald-400 border-emerald-200/50'
                };

                return (
                  <tr key={wo.id} className="text-slate-600 dark:text-slate-400 font-medium">
                    <td className="py-4 font-mono font-bold text-slate-800 dark:text-white">{wo.orderNumber}</td>
                    <td className="py-4 font-semibold text-slate-800 dark:text-slate-300">{wo.productName}</td>
                    <td className="py-4 font-mono text-[10px]">{wo.bomSku}</td>
                    <td className="py-4 w-44">
                      <div className="flex items-center gap-2.5">
                        <div className="flex-1 h-2 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                          <div className="h-full bg-blue-600 rounded-full" style={{ width: `${percent}%` }} />
                        </div>
                        <span className="font-bold text-[10px] w-8">{percent}%</span>
                      </div>
                    </td>
                    <td className="py-4 text-center text-rose-500 font-bold">{wo.scrapQty} units</td>
                    <td className="py-4">
                      <span className={`px-2.5 py-1 rounded-full border text-[10px] font-bold ${statusColors[wo.status]}`}>
                        {wo.status}
                      </span>
                    </td>
                    <td className="py-4">
                      <span className="flex items-center gap-1 text-[10px] text-slate-400 font-semibold">
                        <Calendar className="w-3.5 h-3.5" />
                        {wo.startDate} to {wo.endDate}
                      </span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* Create Order Modal */}
      <AnimatePresence>
        {isNewOrderModalOpen && (
          <div className="fixed inset-0 bg-slate-950/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
            <motion.div
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-xl"
            >
              <h3 className="text-lg font-bold text-slate-800 dark:text-white">Schedule New Work Order</h3>
              <p className="text-xs text-slate-400">Submit a new manufacturing task into the scheduling pipeline.</p>

              <div className="space-y-4">
                <div className="space-y-1.5">
                  <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider block">Finished Assembly</label>
                  <select 
                    value={selectedBOMForOrder}
                    onChange={(e) => setSelectedBOMForOrder(e.target.value)}
                    className="w-full bg-slate-100 dark:bg-slate-800 border-0 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-600 focus:outline-none"
                  >
                    {boms.map(b => (
                      <option key={b.sku} value={b.sku}>{b.finishedGoodName} ({b.sku})</option>
                    ))}
                  </select>
                </div>

                <div className="space-y-1.5">
                  <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider block">Target Output Quantity</label>
                  <input 
                    type="number" 
                    value={newOrderQty}
                    onChange={(e) => setNewOrderQty(Number(e.target.value))}
                    className="w-full bg-slate-100 dark:bg-slate-800 border-0 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-600 focus:outline-none"
                  />
                </div>
              </div>

              <div className="flex justify-end gap-3 pt-2">
                <button 
                  onClick={() => setIsNewOrderModalOpen(false)}
                  className="px-4 py-2 text-xs font-bold text-slate-400 hover:text-slate-600 transition-colors"
                >
                  Cancel
                </button>
                <button 
                  onClick={createWorkOrder}
                  className="px-5 py-2.5 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md shadow-blue-500/20 transition-all"
                >
                  Confirm & Schedule
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
};
