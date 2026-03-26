#!/bin/bash
# Ant Design - Enterprise UI Component Library Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ANT DESIGN REFERENCE                           ║
║          Enterprise-Grade React UI Components               ║
╚══════════════════════════════════════════════════════════════╝

Ant Design (antd) is a React UI library with enterprise-grade
components. Created by Alibaba's Ant Group, it's the most popular
React component library in China and widely used globally.

KEY FEATURES:
  50+ Components    Button, Table, Form, Modal, DatePicker, etc.
  TypeScript        Full type definitions
  i18n              50+ languages built-in
  Theming           CSS-in-JS via @ant-design/cssinjs
  Design System     Comprehensive design tokens
  Accessibility     WCAG 2.0 AA compliance
  Server Rendering  SSR support for Next.js

ANTD vs MATERIAL UI vs CHAKRA:
  ┌──────────────┬──────────┬──────────────┬──────────┐
  │ Feature      │ Ant Design│ Material UI │ Chakra   │
  ├──────────────┼──────────┼──────────────┼──────────┤
  │ Components   │ 50+      │ 40+         │ 30+      │
  │ TypeScript   │ Native   │ Native      │ Native   │
  │ Bundle size  │ Tree-shake│ Tree-shake  │ Small    │
  │ Design lang. │ Ant      │ Material    │ Custom   │
  │ Table/Form   │ Excellent│ Basic       │ Basic    │
  │ DatePicker   │ Built-in │ Separate pkg│ Separate │
  │ Popularity   │ 93K⭐    │ 95K⭐       │ 38K⭐    │
  │ Best for     │ Enterprise│ Consumer   │ Startups │
  └──────────────┴──────────┴──────────────┴──────────┘

INSTALL:
  npm install antd
  # or
  yarn add antd
  # or
  pnpm add antd

BASIC USAGE:
  import { Button, Space } from 'antd';

  function App() {
    return (
      <Space>
        <Button type="primary">Primary</Button>
        <Button>Default</Button>
        <Button type="dashed">Dashed</Button>
        <Button danger>Danger</Button>
      </Space>
    );
  }

VERSION HISTORY:
  v5 (current)  CSS-in-JS, design tokens, no Less dependency
  v4            Less-based theming, still widely used
  v3            Legacy, not maintained
EOF
}

cmd_components() {
cat << 'EOF'
CORE COMPONENTS QUICK REFERENCE
==================================

LAYOUT:
  <Layout>
    <Layout.Header>Header</Layout.Header>
    <Layout>
      <Layout.Sider width={200}>Sidebar</Layout.Sider>
      <Layout.Content>Main Content</Layout.Content>
    </Layout>
    <Layout.Footer>Footer</Layout.Footer>
  </Layout>

  <Row gutter={[16, 16]}>
    <Col span={8}>1/3 width</Col>
    <Col span={8}>1/3 width</Col>
    <Col span={8}>1/3 width</Col>
  </Row>

  <Space direction="vertical" size="large">
    <div>Item 1</div>
    <div>Item 2</div>
  </Space>

NAVIGATION:
  <Menu mode="horizontal" items={[
    { key: 'home', label: 'Home', icon: <HomeOutlined /> },
    { key: 'about', label: 'About' },
    { key: 'sub', label: 'Submenu', children: [
      { key: 'opt1', label: 'Option 1' },
      { key: 'opt2', label: 'Option 2' },
    ]},
  ]} />

  <Breadcrumb items={[
    { title: 'Home', href: '/' },
    { title: 'Products', href: '/products' },
    { title: 'Detail' },
  ]} />

  <Tabs items={[
    { key: '1', label: 'Tab 1', children: 'Content 1' },
    { key: '2', label: 'Tab 2', children: 'Content 2' },
  ]} />

  <Pagination total={500} pageSize={20} showSizeChanger showQuickJumper />

DATA DISPLAY:
  <Card title="Card Title" extra={<a href="#">More</a>}>
    <p>Card content</p>
  </Card>

  <Descriptions title="User Info" bordered>
    <Descriptions.Item label="Name">John</Descriptions.Item>
    <Descriptions.Item label="Email">john@example.com</Descriptions.Item>
  </Descriptions>

  <Tag color="blue">Blue Tag</Tag>
  <Badge count={5}><Avatar shape="square" icon={<UserOutlined />} /></Badge>
  <Statistic title="Active Users" value={112893} prefix={<UserOutlined />} />
  <Timeline items={[{ children: 'Created 2026-01-01' }, { children: 'Updated' }]} />

FEEDBACK:
  <Alert message="Success" type="success" showIcon closable />
  <Spin spinning={loading}><Content /></Spin>
  <Progress percent={80} status="active" />
  <Result status="success" title="Successfully Purchased!" />
  <Skeleton active />   {/* Loading placeholder */}

  // Programmatic:
  message.success('Saved!');
  message.error('Failed!');
  notification.info({ message: 'Update', description: 'New version available' });
  Modal.confirm({ title: 'Delete?', content: 'This cannot be undone' });
EOF
}

cmd_table() {
cat << 'EOF'
TABLE COMPONENT (THE STAR)
============================

Ant Design's Table is its killer feature — far more capable than
most competing libraries.

BASIC TABLE:
  const columns = [
    { title: 'Name', dataIndex: 'name', key: 'name' },
    { title: 'Age', dataIndex: 'age', key: 'age', sorter: (a, b) => a.age - b.age },
    { title: 'Email', dataIndex: 'email', key: 'email' },
    { title: 'Action', key: 'action',
      render: (_, record) => <Button onClick={() => edit(record)}>Edit</Button>
    },
  ];

  <Table dataSource={data} columns={columns} rowKey="id" />

SORTING:
  { title: 'Age', dataIndex: 'age',
    sorter: (a, b) => a.age - b.age,
    sortDirections: ['descend', 'ascend'],
    defaultSortOrder: 'descend',
  }

FILTERING:
  { title: 'Status', dataIndex: 'status',
    filters: [
      { text: 'Active', value: 'active' },
      { text: 'Inactive', value: 'inactive' },
    ],
    onFilter: (value, record) => record.status === value,
  }

PAGINATION:
  <Table pagination={{
    pageSize: 20,
    showSizeChanger: true,
    showQuickJumper: true,
    showTotal: (total) => `Total ${total} items`,
  }} />

SERVER-SIDE:
  <Table
    dataSource={data}
    columns={columns}
    pagination={{ current: page, pageSize, total }}
    loading={loading}
    onChange={(pagination, filters, sorter) => {
      fetchData({
        page: pagination.current,
        pageSize: pagination.pageSize,
        sortField: sorter.field,
        sortOrder: sorter.order,
        ...filters,
      });
    }}
  />

ROW SELECTION:
  <Table rowSelection={{
    type: 'checkbox',
    selectedRowKeys,
    onChange: (keys, rows) => setSelectedRowKeys(keys),
  }} />

EXPANDABLE ROWS:
  <Table expandable={{
    expandedRowRender: (record) => <p>{record.description}</p>,
    rowExpandable: (record) => record.name !== 'Hidden',
  }} />

VIRTUAL SCROLLING (Large datasets):
  import { VirtualTable } from './VirtualTable';
  // Use react-window or rc-virtual-list for 100K+ rows

TREE DATA:
  const data = [
    { key: 1, name: 'Parent', children: [
      { key: 11, name: 'Child 1' },
      { key: 12, name: 'Child 2' },
    ]},
  ];
  <Table dataSource={data} columns={columns} />

EDITABLE CELLS:
  // Use Form + Table combination
  // Each row is a form, cells are form items
  // EditableRow + EditableCell pattern in antd docs
EOF
}

cmd_form() {
cat << 'EOF'
FORM COMPONENT
================

Ant Design Form is a complete form solution with validation,
layout, dynamic fields, and complex data handling.

BASIC FORM:
  import { Form, Input, Button, Select, DatePicker } from 'antd';

  function MyForm() {
    const [form] = Form.useForm();

    const onFinish = (values) => {
      console.log(values);
      // { username: 'john', email: 'john@example.com', role: 'admin' }
    };

    return (
      <Form form={form} layout="vertical" onFinish={onFinish}>
        <Form.Item name="username" label="Username"
          rules={[{ required: true, message: 'Please enter username' }]}>
          <Input placeholder="Enter username" />
        </Form.Item>

        <Form.Item name="email" label="Email"
          rules={[
            { required: true, message: 'Email required' },
            { type: 'email', message: 'Invalid email' }
          ]}>
          <Input />
        </Form.Item>

        <Form.Item name="role" label="Role">
          <Select options={[
            { value: 'admin', label: 'Admin' },
            { value: 'user', label: 'User' },
          ]} />
        </Form.Item>

        <Button type="primary" htmlType="submit">Submit</Button>
      </Form>
    );
  }

VALIDATION RULES:
  { required: true, message: 'Required!' }
  { type: 'email', message: 'Invalid email' }
  { min: 6, message: 'Min 6 characters' }
  { max: 100, message: 'Max 100 characters' }
  { pattern: /^[a-z]+$/, message: 'Lowercase only' }
  { validator: async (_, value) => {
      if (value < 18) throw new Error('Must be 18+');
    }
  }

  // Cross-field validation:
  { validator: (_, value) => {
      if (value === form.getFieldValue('password')) return Promise.resolve();
      return Promise.reject('Passwords do not match');
    }
  }

FORM LAYOUTS:
  <Form layout="horizontal">  {/* Label left, input right (default) */}
  <Form layout="vertical">    {/* Label above input */}
  <Form layout="inline">      {/* All in one line */}

DYNAMIC FIELDS (Form.List):
  <Form.List name="users">
    {(fields, { add, remove }) => (
      <>
        {fields.map(({ key, name }) => (
          <Space key={key}>
            <Form.Item name={[name, 'name']} rules={[{ required: true }]}>
              <Input placeholder="Name" />
            </Form.Item>
            <Form.Item name={[name, 'email']}>
              <Input placeholder="Email" />
            </Form.Item>
            <Button onClick={() => remove(name)}>Remove</Button>
          </Space>
        ))}
        <Button onClick={() => add()}>Add User</Button>
      </>
    )}
  </Form.List>

PROGRAMMATIC CONTROL:
  form.setFieldsValue({ username: 'john', email: 'john@example.com' });
  form.resetFields();
  form.validateFields().then(values => save(values));
  const values = form.getFieldsValue();
  const email = form.getFieldValue('email');
  form.setFields([{ name: 'email', errors: ['Already exists'] }]);
EOF
}

cmd_theming() {
cat << 'EOF'
THEMING & CUSTOMIZATION (v5)
===============================

DESIGN TOKENS (v5):
  import { ConfigProvider } from 'antd';

  <ConfigProvider theme={{
    token: {
      // Brand colors
      colorPrimary: '#1677ff',
      colorSuccess: '#52c41a',
      colorWarning: '#faad14',
      colorError: '#ff4d4f',

      // Typography
      fontSize: 14,
      fontFamily: 'Inter, sans-serif',

      // Border & Radius
      borderRadius: 8,

      // Layout
      colorBgContainer: '#ffffff',
      colorBgLayout: '#f5f5f5',
    },
    components: {
      Button: { colorPrimary: '#00b96b', borderRadius: 20 },
      Input: { borderRadius: 8 },
      Table: { headerBg: '#fafafa' },
    },
  }}>
    <App />
  </ConfigProvider>

DARK MODE:
  import { theme } from 'antd';

  <ConfigProvider theme={{
    algorithm: theme.darkAlgorithm,
    token: { colorPrimary: '#1668dc' },
  }}>
    <App />
  </ConfigProvider>

  // Compact mode:
  <ConfigProvider theme={{ algorithm: theme.compactAlgorithm }}>

  // Combine:
  <ConfigProvider theme={{
    algorithm: [theme.darkAlgorithm, theme.compactAlgorithm],
  }}>

CSS VARIABLES (v5.12+):
  <ConfigProvider theme={{ cssVar: true }}>
    {/* Now you can use --ant-color-primary in CSS */}
  </ConfigProvider>

  .custom { color: var(--ant-color-primary); }

COMPONENT-LEVEL OVERRIDE:
  <ConfigProvider theme={{
    components: {
      Button: {
        colorPrimary: '#00b96b',
        algorithm: true, // Use algorithm to derive colors
      },
      Table: {
        headerBg: '#1f1f1f',
        headerColor: '#ffffff',
        rowHoverBg: '#262626',
      },
    },
  }}>

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Ant Design - Enterprise UI Component Library Reference

Commands:
  intro        Overview, comparison, installation
  components   Layout, navigation, display, feedback
  table        Table sorting, filtering, pagination, editing
  form         Forms, validation, dynamic fields
  theming      Design tokens, dark mode, customization

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  components) cmd_components ;;
  table)      cmd_table ;;
  form)       cmd_form ;;
  theming)    cmd_theming ;;
  help|*)     show_help ;;
esac
