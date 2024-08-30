import Form from '@/app/ui/invoices/edit-form';
import Breadcrumbs from '@/app/ui/invoices/breadcrumbs';
import { fetchCustomers,fetchInvoiceById } from '@/app/lib/data';
import { notFound } from 'next/navigation';
 
export default async function Page({params}:{params: {id: string}}) {

    const id = params.id;
    const [invoice,customers] = await Promise.all([
        fetchInvoiceById(id),
        fetchCustomers()
    ])

    if(!invoice) {
        // 这里默认会加载默认的页面，如果我们定义了 not-found.tsx，就会加载我们定义的页面
        // notFound 将优先于 error.tsx
        notFound();
    }

  return (
    <main>
      <Breadcrumbs
        breadcrumbs={[
          { label: 'Invoices', href: '/dashboard/invoices' },
          {
            label: 'Edit Invoice',
            href: `/dashboard/invoices/${id}/edit`,
            active: true,
          },
        ]}
      />
      <Form invoice={invoice} customers={customers} />
    </main>
  );
}