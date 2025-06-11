import React, { useState } from 'react';
import { Retool } from '@tryretool/custom-component-support';

type CampaignNode = {
  name: string;
  Cost?: number;
  Revenue?: number;
  Sessions?: number;
  Transactions?: number;
  NewUsers?: number;
  GA_last_click_revenue?: number;
  Attributed_Revenue?: number;
  Revenue_minus_embedded_awareness?: number;
  embedded_awareness?: number;
  Date?: string;
  children?: CampaignNode[];
};

export const CampaignTree = () => {
  const [data] = Retool.useStateObject({
    name: 'data',
    label: 'Campaign Data',
    inspector: 'text',
    description: 'Nested campaign hierarchy'
  });

  const [layout] = Retool.useStateArray({
    name: 'layout',
    label: 'Nesting Layout',
    inspector: 'text',
    description:
      'JSON array of field names that defines the nesting order. Use "topClassification" for computed top level.',
    initialValue: ['topClassification', 'New_mapping', 'Campaign_Nm']
  });

  const [expandedKeys, setExpandedKeys] = useState<Record<string, boolean>>({});

  const toggleRow = (key: string) => {
    setExpandedKeys(prev => ({
      ...prev,
      [key]: !prev[key]
    }));
  };

  const columnToRow = (cols: Record<string, any>): any[] => {
    if (!cols || typeof cols !== 'object') return [];
    const keys = Object.keys(cols);
    const length = cols[keys[0]]?.length || 0;
    return Array.from({ length }, (_, i) => {
      const row: Record<string, any> = {};
      keys.forEach(k => row[k] = cols[k][i]);
      return row;
    });
  };

  const classifyTopLevel = (row: any): string => {
    const mapping = (row.New_mapping || '').toLowerCase();
    if (mapping.includes('shopping')) return 'Shopping';
    if (mapping.includes('search')) return 'Search';
    if (mapping.includes('social') || mapping.includes('facebook') || mapping.includes('tiktok')) return 'Social';
    if (mapping.includes('display') || mapping.includes('daba')) return 'Display';
    if (mapping.includes('organic') || mapping.includes('not set') || mapping.includes('affiliate')) return 'Non-Paid';
    return 'Other';
  };

  const rowsRaw = columnToRow(data);
  const grouped: CampaignNode[] = [];

  const insertRow = (
    nodes: CampaignNode[],
    row: any,
    depth: number,
    keys: string[]
  ) => {
    const key = keys[depth];
    const value =
      key === 'topClassification'
        ? classifyTopLevel(row)
        : row[key] || '(Unnamed)';

    let node = nodes.find(n => n.name === value);
    if (!node) {
      node = { name: value, children: [] };
      nodes.push(node);
    }

    if (depth === keys.length - 1) {
      node.children!.push({
        name: row.Campaign_Nm || value,
        Cost: row.Cost,
        Revenue: row.Revenue,
        Sessions: row.Sessions,
        Transactions: row.Transactions,
        NewUsers: row.NewUsers,
        GA_last_click_revenue: row.GA_last_click_revenue,
        Attributed_Revenue: row.Attributed_Revenue,
        Revenue_minus_embedded_awareness: row.Revenue_minus_embedded_awareness,
        embedded_awareness: row.embedded_awareness,
        Date: row.Latest_Date || row.Date
      });
    } else {
      insertRow(node.children!, row, depth + 1, keys);
    }
  };

  const sumMetrics = (nodes: CampaignNode[]): CampaignNode => {
    const totals: CampaignNode = {
      name: '',
      Cost: 0,
      Revenue: 0,
      Sessions: 0,
      Transactions: 0,
      NewUsers: 0,
      GA_last_click_revenue: 0,
      Attributed_Revenue: 0,
      Revenue_minus_embedded_awareness: 0,
      embedded_awareness: 0,
      children: []
    };
    nodes.forEach(mid => {
      (mid.children || []).forEach(row => {
        totals.Cost! += row.Cost || 0;
        totals.Revenue! += row.Revenue || 0;
        totals.Sessions! += row.Sessions || 0;
        totals.Transactions! += row.Transactions || 0;
        totals.NewUsers! += row.NewUsers || 0;
        totals.GA_last_click_revenue! += row.GA_last_click_revenue || 0;
        totals.Attributed_Revenue! += row.Attributed_Revenue || 0;
        totals.Revenue_minus_embedded_awareness! += row.Revenue_minus_embedded_awareness || 0;
        totals.embedded_awareness! += row.embedded_awareness || 0;
      });
    });
    return totals;
  };

  const layoutKeys =
    Array.isArray(layout) && layout.length > 0
      ? (layout as string[])
      : ['topClassification', 'New_mapping', 'Campaign_Nm'];

  rowsRaw.forEach(row => {
    insertRow(grouped, row, 0, layoutKeys);
  });

  const renderRows = (nodes: CampaignNode[], depth = 0, parentKey = ''): JSX.Element[] => {
    if (!Array.isArray(nodes)) {
      return [
        <tr key="no-data">
          <td colSpan={10}>No data or invalid format</td>
        </tr>
      ];
    }
    return nodes.flatMap((node, index) => {
      const key = `${parentKey}-${index}`;
      const isExpanded = expandedKeys[key];
      const hasChildren = Array.isArray(node.children) && node.children.length > 0;

      let subtotal: CampaignNode | undefined;
      if (hasChildren) {
        subtotal = sumMetrics(node.children!);
      }

      return [
        <tr key={key} style={{ fontWeight: hasChildren ? 'bold' : 'normal', background: hasChildren ? '#f9f9f9' : 'inherit' }}>
          <td style={{ paddingLeft: `${depth * 20}px` }}>
            {hasChildren && (
              <button onClick={() => toggleRow(key)} style={{ marginRight: '6px' }}>
                {isExpanded ? '▾' : '▸'}
              </button>
            )}
            {node.name}
          </td>
          <td>{subtotal?.Cost?.toFixed(2) ?? node.Cost?.toFixed(2) ?? ''}</td>
          <td>{subtotal?.Revenue?.toFixed(2) ?? node.Revenue?.toFixed(2) ?? ''}</td>
          <td>{subtotal?.Sessions ?? node.Sessions ?? ''}</td>
          <td>{subtotal?.Transactions ?? node.Transactions ?? ''}</td>
          <td>{subtotal?.NewUsers ?? node.NewUsers ?? ''}</td>
          <td>{subtotal?.GA_last_click_revenue?.toFixed(2) ?? node.GA_last_click_revenue?.toFixed(2) ?? ''}</td>
          <td>{subtotal?.Attributed_Revenue?.toFixed(2) ?? node.Attributed_Revenue?.toFixed(2) ?? ''}</td>
          <td>{subtotal?.Revenue_minus_embedded_awareness?.toFixed(2) ?? node.Revenue_minus_embedded_awareness?.toFixed(2) ?? ''}</td>
          <td>{subtotal?.embedded_awareness?.toFixed(2) ?? node.embedded_awareness?.toFixed(2) ?? ''}</td>
        </tr>,
        ...(isExpanded && hasChildren ? renderRows(node.children!, depth + 1, key) : [])
      ];
    });
  };

  return (
    <div style={{ fontFamily: 'sans-serif', padding: '12px' }}>
      <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '14px' }}>
        <thead>
          <tr style={{ textAlign: 'left', borderBottom: '2px solid #ccc' }}>
            <th>Name</th>
            <th>Cost</th>
            <th>Revenue</th>
            <th>Sessions</th>
            <th>Transactions</th>
            <th>New Users</th>
            <th>GA Last Click Rev</th>
            <th>Attributed Rev</th>
            <th>Rev minus Awareness</th>
            <th>Embedded Awareness</th>
          </tr>
        </thead>
        <tbody>{renderRows(grouped)}</tbody>
      </table>
    </div>
  );
};

export default CampaignTree;